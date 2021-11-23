# Ruby Chess

## Overview

This is a CLI chess game written in Ruby for [The Odin Project](https://www.theodinproject.com/paths/full-stack-ruby-on-rails/courses/ruby-programming/lessons/ruby-final-project).

## Preview


## How to Play
- Clone this repo and run `ruby lib/main.rb`
- Play online at [repl.it](http://www.google.com)
## Features
### Gameplay
- Castling (treated as a King move when playing)
- En passant captures
- Includes all forced draws
    - Stalemate
    - Five fold repetition [reference](https://en.wikipedia.org/wiki/Threefold_repetition#Fivefold_repetition_rule)
    - 75 move rule [reference](https://en.wikipedia.org/wiki/Fifty-move_rule#Seventy-five-move_rule)
    - Insufficient material [reference](https://en.wikipedia.org/wiki/Rules_of_chess#Dead_position)

-  A very simple AI that is capable of playing a random move.  (Maybe A rather than AI!)
### Saving/Loading
-  Games can be saved and resumed at a later date.
-  Saves are stored for 30 days only to prevent bloat since it is not expected that this will be played in any serious manner.
## Requirements
- Ruby 2.7.2 or newer

## Reflections
Chess is complicated and surprisingly hard to write.  This is a far from perfect implementation and was never intended to be one.  It has been a tremendous growth experience in problem solving, understanding Ruby, writing tests, and general determination.  I could tinker for this with ages and never be completely happy with the result, but it is at a good place at the time of writing this.

One thing I really tried to focus on was splitting behavior into smaller classes rather than writing a few giant ones.  This really helped with a lot of testing since the smaller classes could be tested more easily and independently.  Some classes were done with TDD and I believe the benefits tend to outweigh any extra time spent doing so.

Planning is important.  Early on I had a limited understanding of some chess rules and felt like some of the implementations I came up with could have been better had I planned them out earlier in the process.  Some of the later additions felt more like scope creep than a requirement.

## Possible Improvements
If I were to return in the future for modifications I would probably look at:

  - Menus: Using arrows keys to move around a menu instead of having to input 1 or 2 in many cases.
  - Display:  More information on the turn display for half move clock, castling rights, and/or the active en passant target.
  - AI: Any kind of intelligence.
  - Saving: Work towards a [PGN](https://en.wikipedia.org/wiki/Portable_Game_Notation) compatible save game.
  - Design:  I designed as I went due to lack of design pattern knowledge.  There's a chance that there is a well known design patter than would have solved or made easier some of the issues I faced along the way.