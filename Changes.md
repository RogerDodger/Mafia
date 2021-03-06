Mafia.pm changelog
==================

v0.4
----

- Added Mafia::Markdown which inherits and mofidies Markdown for our purposes
  - proper autolinking of URLs and citations ("#15 says. . .")
- Width variables in stylesheet changed to being measured in em
- renamed _markup() to _render(), which now also returns the IDs of all cites

v0.3 - 01 Mar 2013
------------------

- post/submit.html (and associated style) mostly complete
  - Bold/italics/quote/link buttons working
  - Reply buttons working
  - Post preview working
- Logger added, writes to file in production and to STDERR in development (-Debug)
- Added _markup() to Result::Post, which renders posts from user input into HTML
- Added version() to TraitFor::Script
- New script `mafia_compile_less.pl`
- Added Mafia::URI which acts as a Catalyst plugin, providing a uri_for_glob() routine
- Config is application agnostic, and application does not install so that scripts work more predictably

v0.2 - 03 Feb 2013
------------------

- Got a decent wrapper in place so that work can begin
  - Site is fixed width and utilises floats
    - Surprisingly nice to work with when you do it right (which I hope I am)
  - May use javascript to shrink it for short screens
- Initial work on post/thread template & style
  - Posts have durations listed for their timestamps
  - Using sun/moon symbols to show game date and day/night
  - System messages are slightly darker and have no poster name

Currently using static `team` rows for player teams along with the `player` roles,
where the teams can be any of Town, Mafia, Nomad, Bratva, and Yakuza, the latter two
of which are simply Mafia clones, i.e., so you can play with multiple Mafia. (Bratva 
are the Russian "brotherhood", and Yakuza the Japanese Mafia, so I figured they'd be 
decent names.)

Setups are... rather complex. A setup can have multiple "groups" in the case of being
semi-open. Each group consists of a series of roles, which have assigned teams. (For
roles that aren't mafia, these will be fixed, but there has to be some way to make
the Bratva/Yakuza work without duplicating every role twice.)

How this information can be displayed compactly... I'm not so sure. And entering it?
With basic HTML forms too? Haha, no way. I don't think I'll lose sleep if people
who've disabled javascript can't make setups.

A setup can't be played until marked as final, at which point it cannot be changed.
This is so that setup stats are actually representative, and so comments on setups
(once implemented, not really high prio though) actually make sense.

A setup can be marked as private if someone wants to host a closed setup, in which
case nobody can see what the setup is.

v0.1 - 13 Dec 2012
------------------

- Vague idea of data schema implemented
