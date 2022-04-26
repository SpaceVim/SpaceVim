# Contributing

This document is the official contribution guide contributors must follow. It will be **greatly appreciated** if you
read it first before contributing. It will also prevent you from losing your time if you open an issue / make a PR that
doesn’t comply to this document.

<!-- vim-markdown-toc GFM -->

* [Disclaimer and why this document](#disclaimer-and-why-this-document)
* [How to make a change](#how-to-make-a-change)
  * [Process](#process)
* [Conventions](#conventions)
  * [Coding](#coding)
  * [Git](#git)
    * [Git message](#git-message)
    * [Commit atomicity](#commit-atomicity)
    * [Hygiene](#hygiene)
* [Release process](#release-process)
  * [Overall process](#overall-process)
  * [Changelogs update](#changelogs-update)
  * [Git tag](#git-tag)
* [Support and donation](#support-and-donation)

<!-- vim-markdown-toc -->

# Disclaimer and why this document

People contributing is awesome. The more people contribute to Free & Open-Source software, the better the
world is to me. However, the more people contribute, the more work we have to do on our spare-time. Good
contributions are highly appreciated, especially if they thoroughly follow the conventions and guidelines of
each and every repository. However, bad contributions — that don’t follow this document, for instance — are
going to require me more work than was involved into making the actual change. It’s even worse when the contribution
actually solves a bug or add a new feature.

So please read this document; it’s not hard and the few rules here are easy to respect. You might already do
everything in this list anyway, but reading it won’t hurt you. For more junior / less-experienced developers, it’s
very likely you will learn a bit of process that is considered good practice, especially when working with VCS like
Git.

> Thank you!

# How to make a change

## Process

The typical process is to base your work on the `master` branch. The `master` branch must always contain a stable
version of the project. It is possible to make changes by basing your work on other branches but the source
of truth is `master`. If you want to synchronize with other people on other branches, feel free to.

The process is:

1. (optional) Open an issue and discuss what you want to do. This is optional but highly recommended. If you
  don’t open an issue first and work on something that is not in the scope of the project, or already being
  made by someone else, you’ll be working for nothing. Also, keep in mind that if your change doesn’t refer to an
  existing issue, I will be wondering what is the context of your change. So prepare to be asked about the motivation
  and need behind your changes — it’s greatly appreciated if the commit messages, code and PR’s content already
  contains this information so that people don’t have to ask.
2. Fork the project.
3. Create a branch starting from `master` – or the branch you need to work on. Even though this is not really enforced,
  you’re advised to name your branch according to the _Git Flow_ naming convention:
  - `fix/your-bug-here`: if you’re fixing a bug, name your branch.
  - `feature/new-feature-here`: if you’re adding some work.
  - Free for anything else.
  - The special `release/*` branch is used to either back-port changes from newer versions to previous
    versions, or to release new versions by updating files, changelogs, etc. Normally, contributors should
    never have to worry about this kind of brach as their creations is often triggered when wanting to make a release.
4. Make some commits!
5. Once you’re ready, open a Pull Request (PR) to merge your work on the target branch. For instance, open a PR for
  `master <- feature/something-new`.
6. (optional) Ask someone to review your code in the UI. Normally, I’m pretty reactive to notifications but it never
  hurts to ask for a review.
7. Discussion and peer-review.
8. Once the CI is all green, someone (likely me [@phaazon]) will merge your code and close your PR.
9. Feel free to delete your branch.

# Conventions

## Coding

N/A

## Git

### Git message

Please format your git messages like so:

> Starting with an uppercase letter, ending with a dot. #343
>
> The #343 after the dot is appreciated to link to issues. Feel free to add, like this message, more context
> and/or precision to your git message. You don’t have to put it in the first line of the commit message,
> but if you are fixing a bug or implementing a feature thas has an issue linked, please reference it, so
> that it is easier to generate changelogs when reading the git log.

**I’m very strict on git messages as I use them to write `CHANGELOG.md` files. Don’t be surprised if I ask you
to edit a commit message. :)**

### Commit atomicity

Your commits should be as atomic as possible. That means that if you make a change that touches two different
concepts / has different scopes, most of the time, you want two commits – for instance one commit for the backend code
and one commit for the interface code. There are exceptions, so this is not an absolute rule, but take some time
thinking about whether you should split your commits or not. Commits which add a feature / fix a bug _and_ add tests at
the same time are fine.

However, here’s a non-comprehensive list of commits considered bad and that will be refused:

- **Formatting, refactoring, cleaning, linting code in a PR that is not strictly about formatting**. If you open a PR to
  fix a bug, implement a  feature, change configuration, add metadata to the CI, etc. — pretty much anything — but you
  also format some old code that has nothing to do with your PR, apply a linter’s suggestions (such as `clippy`), remove
  old code, etc., then I will refuse your commit(s) and ask you to edit your PR.
- **Too atomic commits**. If two commits are logically connected to one another and are small, it’s likely that you want
  to merge them as a single commit — unless they work on too different parts of your code. This is a bit subjective
  topic, so I won’t be _too picky_ about it, but if I judge that you should split a commit into two or fixup two commits,
  please don’t take it too personal. :)

If you don’t know how to write your commits in an atomic maneer, think about how one would revert your commits if
something bad happens with your changes — like a big breaking change we need to roll back from very quickly. If your
commits are not atomic enough, rolling them back will also roll back code that has nothing to do with your changes.

### Hygiene

When working on a fix or a feature, it’s very likely that you will periodically need to update your branch
with the `master` branch. **Do not use merge commits**, as your contributions will be refused if you have
merge commits in them. The only case where merge commits are accepted is when you work with someone else
and are required to merge another branch into your feature branch (and even then, it is even advised to
simply rebase). If you want to synchronize your branch with `master`, please use:

```
git switch <your_branch>
git fetch origin --prune
git rebase origin/master
```

# Release process

## Overall process

Releases occur at arbitrary rates. If something is considered urgent, it is most of the time released immediately
after being merged and tested. Sometimes, several issues are being fixed at the same time (spanning on a few
days at max). Those will be gathered inside a single update.

Feature requests might be delayed a bit to be packed together as well but eventually get released, even if
they’re small. Getting your PR merged means it will be released _soon_, but depending on the urgency of your changes,
it might take a few minutes to a few days.

## Changelogs update

`CHANGELOG.md` files must be updated **before any release**. Especially, they must contain:

- The version of the release.
- The date of the release.
- How to migrate from a minor to the next major.
- Everything that a release has introduced, such as major, minor and patch changes.

Because I don’t ask people to maintain changelogs, I have a high esteem of people knowing how to use Git and create
correct commits. Be advised that I will refuse any commit that prevents me from writing the changelog correctly.

## Git tag

Once a new release occurs, a Git tag is created. Git tags are formatted regarding the project they refer to, if several
projects are present in the repository. If only one project is present, tags will refer to this project by the same
naming scheme anyway:

> <project-name>-X.Y.Z

Where `X` is the _major version_, `Y` is the _minor version_ and `Z` is the _patch version_. For instance
`project-0.37.1` is a valid Git tag, so is `project-derive-0.5.3`.

A special kind of tag is also possible:

> <project-name>-X.Y.Z-rc.W

Where `W` is a number starting from `1` and incrementing. This format is for _release candidates_ and occurs
when a new version (most of the time a major one) is to be released but more feedback is required.

# Support and donation

This project is a _free  and  open-source_ project. It has no financial motivation nor support. I
([@phaazon]) would like to make it very clear that:

- Sponsorship is not available. You cannot pay me to make me do things for you. That includes issues reports,
  features requests and such.
- If you still want to donate because you like the project and think I should be rewarded, you are free to
  give whatever you want.
- However, keep in mind that donating doesn’t unlock any privilege people who don’t donate wouldn’t already
  have. This is very important as it would bias priorities. Donations must remain anonymous.
- For this reason, no _sponsor badge_ will be shown, as it would distinguish people who donate from those
  who don’t. This is a _free and open-source_ project, everybody is welcome to contribute, with or without
  money.

[@phaazon]: https://github.com/phaazon
