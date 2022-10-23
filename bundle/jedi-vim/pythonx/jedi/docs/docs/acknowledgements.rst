.. include global.rst

History & Acknowledgements
==========================

Acknowledgements
----------------

- Dave Halter for creating and maintaining Jedi & Parso.
- Takafumi Arakaki (@tkf) for creating a solid test environment and a lot of
  other things.
- Danilo Bargen (@dbrgn) for general housekeeping and being a good friend :).
- Guido van Rossum (@gvanrossum) for creating the parser generator pgen2
  (originally used in lib2to3).
- Thanks to all the :ref:`contributors <contributors>`.

A Little Bit of History
-----------------------

Written by Dave.

The Star Wars Jedi are awesome. My Jedi software tries to imitate a little bit
of the precognition the Jedi have. There's even an awesome `scene
<https://youtu.be/yHRJLIf7wMU>`_ of Monty Python Jedis :-).

But actually the name has not much to do with Star Wars. It's part of my
second name Jedidjah.

I actually started Jedi back in 2012, because there were no good solutions
available for VIM. Most auto-completion solutions just did not work well. The
only good solution was PyCharm. But I liked my good old VIM very much. There
was also a solution called Rope that did not work at all for me. So I decided
to write my own version of a completion engine.

The first idea was to execute non-dangerous code. But I soon realized, that
this would not work. So I started to build a static analysis tool.
The biggest problem that I had at the time was that I did not know a thing
about parsers.I did not did not even know the word static analysis. It turns
out they are the foundation of a good static analysis tool. I of course did not
know that and tried to write my own poor version of a parser that I ended up
throwing away two years later.

Because of my lack of knowledge, everything after 2012 and before 2020 was
basically refactoring. I rewrote the core parts of Jedi probably like 5-10
times. The last big rewrite (that I did twice) was the inclusion of
gradual typing and stubs.

I learned during that time that it is crucial to have a good understanding of
your problem. Otherwise you just end up doing it again. I only wrote features
in the beginning and in the end. Everything else was bugfixing and refactoring.
However now I am really happy with the result. It works well, bugfixes can be
quick and is pretty much feature complete.

--------

I will leave you with a small annectote that happend in 2012, if I remember
correctly. After I explained Guido van Rossum, how some parts of my
auto-completion work, he said:

    *"Oh, that worries me..."*

Now that it is finished, I hope he likes it :-).

.. _contributors:

.. include:: ../../AUTHORS.txt
