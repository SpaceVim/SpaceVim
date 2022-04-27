# Hop hint modes refined: an extensible model

This document is a design document presenting a redesign of Hop’s « hint modes » to allow for a better customization
experience for people using Hop.


<!-- vim-markdown-toc GFM -->

* [Context](#context)
* [Analysis](#analysis)
* [Prior and on-going work](#prior-and-on-going-work)
* [Solution](#solution)
  * [Redesign `HintMode`](#redesign-hintmode)
  * [Rewrite the public interface to support already existing modes](#rewrite-the-public-interface-to-support-already-existing-modes)
  * [Part of the work that can be taken out of #123](#part-of-the-work-that-can-be-taken-out-of-123)
* [Alternatives](#alternatives)
* [Rationale](#rationale)
* [Future work](#future-work)

<!-- vim-markdown-toc -->
# Context

The current code uses the concept of _hint modes_ to work. Hop goes through all the visible lines and applies the hint
mode on each line, extracting _jump targets_. The jump targets are then associated with permutations, and the sum of
those properties makes a _hint_.

The goal is to be able to abstract away from this representation and create more general jump targets, so that the core
of Hop can be built using this new model, but also dependent users can:

- Build other plugins using the Hop API to create their own jump target and then be able to jump to them.
- Extend the possible hint modes to provide more Hop motion without necessarily having to merge their code upstream.
  This is especially true as some needs are not necessarily something that should be maintained in Hop directly, such
  as Treesitter targets which are considered not really interesting. Nevertheless, if some users would like to be able
  to use Treesitter as a source of targets, Hop should provide a powerful enough API to allow people to do just that.

Currently, there is no way (besides pushing code) to extend Hop features. Because we want to let _programmers_ extend
Hop, there is no question to let _users_ extend it. What that means is that if a new motion is wanted, two possible
options are available:

- The motion is implemented as a local Lua function / Vim command mapped in the user configuration.
- Someone makes a plugin exposing the Lua function / a Vim command and implementing the motion.
- A possible third option that is unlikely but still possible would be that the motion is small and useful enough to
  merge it upstream in https://github.com/phaazon/hop.nvim.

# Analysis

In order to understand how the code is currently working, we can have a look at it from a user perspective. They are
likely to use, either:

- The Vim commands, exposed in `pugin/hop.vim`.
- The Lua API public functions, in `lua/hop/init.lua`.

The Lua functions to use start with `hint_`. For instance, `hint_words()` (`:HopWord`). `hint_words` is defined as:

```lua
function M.hint_words(opts)
  hint_with(hint.by_word_start, get_command_opts(opts))
end
```

`hint_patterns`, `hint_char1`, etc. are defined in a similar fashion. `hint_with` is the current (local) function used
to build other hint modes. It takes a `HintMode` as argument and the user options, and builds applies the hint mode.
This is the function that needs to be changed. It must, first, be publicly available. Then, the way the hint modes are
applied need to change. For instance, if a user wants to use Hop with their own jump targets (without having to scan
the visible part of the buffer), they should be able to.

The `hint_with` function is a pretty complex function that does a lot of things:

- It extracts a bunch of information about the current visible part of the buffer. This is useful not to create hints
  for text that the user cannot see.
- It supports various optinos, such as direction hinting (before cursor, after cursor, current-line-only, etc.).
- It creates the highlight groups.
- Get the buffer lines so that hint modes can be applied on.
- Call the hint modes and reduce hints until a match is found.
- Do the actual jump.

`hint_mode`, the `HintMode` argument assed to `hint_with`, is used like this:

- It contains a `curr_line_only` boolean that allows to know whether the hinting should be restricted to the current
  line only.
- It is passed to `hop.hint.create_hints` to create the hints. To do so, it is passed to other functions that will call
  the `match` function on it. What it does is to generate a pair of values allowing to pin-point where the jump
  targets are. It is not really an iterator as it returns _spans_ value (i.e. beginning / end), so we have to manually
  shift lines to know where and when to stop.
- It contains a `oneshot` boolean that is mostly an implementation detail for the `match` loop to work. If it’s
  `oneshot`, the loop breaks at the first iteration. This is useful for line hinting for instance, where only one jump
  target should exist on each line.

So a couple of things to change here, obviously.

# Prior and on-going work

Some PRs have been pushed to attempt to solve this problem:

- [#123](https://github.com/phaazon/hop.nvim/pull/123): refactor hint strategies. Unfortunately, this PR wasn’t reviewed
  until late and had conflicting changes. Also, this PR changed too many things, refactoring things that don’t really
  have to be at this point (or not making sense to move around). However, the work can probably be partially taken out
  and rebased in other commits, so that this work is not lost.
- [#133](https://github.com/phaazon/hop.nvim/pull/133): this one is a bit weird, as its scope could be have been split
  into several PRs. The multi-windows support is probably something that will come later once hint modes are refactored.
  The dict support to allow to pass a dict of things is interesting but that’s also a feature that should be added
  later, once the code is refactored.

So clearly, we need to do something about #123 first. #133 will then be rebased and should be smaller.

# Solution

## Redesign `HintMode`

The first thing that needs to be done is to change change `HintMode` so that it doesn’t assume to run line-by-line. The
thing is, `hint_with` should be its own hint mode (that iterates over the lines of the currently visible part of the
buffer and extract jump targets). A `HintMode` should then be:

- A function that provides the jump targets. We need to provide some functions to be able to get visible lines for
  instance for people who still want to operate on these. The idea is that once this function has run, it must provide a
  dict of jump targets by buffer. Something like:

```lua
{
  -- jump target for a buffer
  {
    buffer_handle = 124,
    jump_targets = {
      { line = 67, column = 4},
      { line = 67, column = 7},
      -- …
    },
  },

  -- another jump target for another buffer…
}
```

- The code that creates hints (`hop.hint.create_hints`) then must only call that function and do the regular, currently
  implemented algorithm associating jump targets with permutations to generate the actual hints.
- The hint reduction can occur as it normally does.

This solution removes `oneshot` and `match`, leaving hint modes as a simple generator function providing the list of
jump targets. However, doing this will require to move some code around to help writing those jump target generators.
For instance, the logic that goes line-by-line, extracting word patterns for instance, is not trivial and is very tricky
to implement (multi-byte, virtualedit, etc.). So this must stay around. Something we can probably do here is to provide
a function that will output a `HintMode` going line-by-line and applying the logic passed as argument. Also, I suggest
to change the name `HintMode` to `JumpTargetGenerator`, which makes more sense.

About the actual function generating the list, something that goes to mind: should we make this a fully synchronous
function that will return all the targets at once, or should we make this an actual generator? I.e. calling it will
return the first jump target, then calling it a second time will return the next jump target, etc. I think it can have
interesting use-cases but it will probably slow everything down for probably not something super interesting.

This design seems to be pretty similar to what was planned in #123, so there is probably some commits to extract from
that PR.

## Rewrite the public interface to support already existing modes

Currently, the following modes are available:

- `HopWord`: hint words.
- `HopWordBC`: same as above, but _before cursor_.
- `HopWordAC`: same as above, but _after cursor_.
- `HopPattern`: hint pattern (manually entered by the user with `input`).
- `HopPatternBC`: same as above, but _before cursor_.
- `HopPatternAC`: same as above, but _after cursor_.
- `HopChar1`: hint the current buffer by pressing one character to select which ones to jump to.
- `HopChar1BC`: same as above but _before cursor_.
- `HopChar1AC`: same as above but _after cursor_.
- `HopChar2`: hint the current buffer by pressing two characters to select which ones to jump to.
- `HopChar2BC`: same as above but _before cursor_.
- `HopChar2AC`: same as above but _after cursor_.
- `HopLine`: hint lines (first column).
- `HopLineBC`: same as above but _before cursor_.
- `HopLineAC`: same as above but _after cursor_.
- `HopLineStart`: hint lines (first non whitespace character).
- `HopLineStartBC`: same asbove but _before_cursor_.
- `HopLineStartAC`: same asbove but _after cursor_.
- `HopChar1Line`: same as `HopChar1` but applies only to the current line.
- `HopChar1LineAC`: same asbove but _before_cursor_.
- `HopChar1LineBC`: same asbove but _after cursor_.

All those commands need to be re-implemented with the new `JumpTargetGenerator` design. All the current commands are
based on scanning line-by-line the currently visible part of the buffer, so we will want a function creating a
`JumpTargetGenerator` that implements this logic. Its arguments should allow us to implement all of the commands above.
The important thing to understand is that the `*BC` and `*AC` variations are actually the same mode but applied with the
user configuration (i.e. `direction`). Restricting to the same line should probably also be a user-configuration option
to allow using `HopWord` only on the current line, for instance.

## Part of the work that can be taken out of #123

Given all the work described here, here is a break down view of the PR:

- [5f93a87d](https://github.com/phaazon/hop.nvim/pull/123/commits/5f93a87d57c4926ceb1f71898c96e777c2ff33d6):
  refactoring / code hygiene. **Will pick**.
- [bc449524](https://github.com/phaazon/hop.nvim/pull/123/commits/bc449524605317f48aff824f55e8a0e2ed40d87e): move
  `HintMode` to a new weird `constants.lua` module. This adds no value. **Will drop**.
- [adbab40e](https://github.com/phaazon/hop.nvim/pull/123/commits/adbab40ef97f1516dd301bb7c9b9e66bc3638c39): move
  all the logic of getting the visible buffer part into a `get_window_context` function. This is interesting but will
  require a bit of fixup work. **Will pick**.
- [30d35b94](https://github.com/phaazon/hop.nvim/pull/123/commits/30d35b9479a42feaca35707c5176d47ce7a6e58d): introduce
  the concept of _aggregate_ to refactor the process of mapping jump targets (`indirect_hints`) with permutations to
  yield `hints`. I’m not a huge fan of the terminology, it doesn’t really convey what the aggregates are for. We need to
  change the terminology, but I will probably use that too. **Will pick**.
- [e8c84c11](https://github.com/phaazon/hop.nvim/pull/123/commits/e8c84c11a2a085d8df108772ad0c6d41571a3aa1): move out
  associating permutations to jump targets. I’m mostly okay with this, but we need to change the name of the function so
  that it’s clear that the function now only creates jump targets, and another function adds the permutations to it.
  This function still uses the _aggregate_ concept introduced in the previous commit, for which we need to change the
  terminology. **Will pick**.
- [c8fa480c](https://github.com/phaazon/hop.nvim/pull/123/commits/c8fa480ce593296dcf49dd0ff7401ed930bafcf1): change the
  semantics of hint modes to use `get_hints` instead of scanning lines by lines. We need to change the name so that it’s
  something like `get_jump_targets` instead. **Will pick**.
- [9fc5d517](https://github.com/phaazon/hop.nvim/pull/123/commits/9fc5d51785a2819ecc2f7ce72fbaf3f8ad092ff9): remove
  length from the output of the function creating the hints. This commit might be dangerous, because the reason for
  having the length is important (it allows to ensure we cut currently the hints if they overlap / are at the end of a
  `wrap` window). **Not sure, probably will drop**.
- [8a482a98](https://github.com/phaazon/hop.nvim/pull/123/commits/8a482a98041433fb924807a0b53f231327db90c2): replace the
  concept of _aggregate_ with _hint list_ (should be _jump target list_) and general refactoring. Not sure whether I
  will use this as the rest of the design will probably be left to implement regarding this current document. **Not
  sure, probably will pick**.
- [82117eab](https://github.com/phaazon/hop.nvim/pull/123/commits/82117eab12f6f3278927667623ed4c267608a22e):
  documentation enhancement. **Will pick**.

The actual commits that were picked were not the ones described just above because decisions to refactor / renames
things in a different way that matches more the overall design.

# Alternatives

Besides merging code upstream, there is no real alternative to this problem. We have to expose the jump target retreival
on the public API so that people can extend Hop the way they want.

# Rationale

This redesign should allow to people to extend Hop on their side without having to merge code upstream. Different
motivations exist, among people wanting to use Treesitter-based motions, which will _not_ end up upstream as I think
it’s not really interesting / useful / out of scope, because hints are more a visual thing than a semantics thing;
people wanting to use Hop in menus / interfaces, etc.

The other good point of this redesign is that we still support the _user configuration_ that is very important to the
author ([@phaazon](https://github.com/phaazon)).

Another interesting aspects of this redesign is to allow people to create Lua plugins that might end up upstream if
needed, but people wanting to create « extensions » plugins will not have to depend on the upstream to have it possible.
This is important for two reasons:

- People can implement their workflow.
- Hop can remain small and thus is much easier to maintain.

In order to help plugin authors to write their Hop extension, we will have to keep the documentation updated and
top of the notch.

# Future work

An important matter while I was writing this design doc: because we are probably going to have people implementing
extensions, they are going to use the public API of Hop, which will probably have deprecations / breaking-change at some
point. I have parallel work on going (i.e. [poesie.nvim](https://github.com/phaazon/poesie.nvim)) but ultimately, I
really want a SemVer API, so that plugin authors don’t have to worry too much about this. It’s more about the end-users:
I really dislike it when I update something and it breaks because of a deprecation somewhere. People have their lives,
they won’t update immediately, so we need SemVer to prevent that kind of problems from occurring. We need to keep that
in mind for later because this Hop extension thing is going to a perfect example about why we need this. I’m explicitely
pinging [@mjlbach](https://github.com/mjlbach) as we mentioned that quite a few times lately, and to show that Hop is
going to _really_ need this. I might probably implement a convention in poesie and givin what the core team want to do
regarding plugins (whether their version will be checked in the core or whether poesie / something else should be
responsible for it).
