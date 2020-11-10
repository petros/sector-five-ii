Sector Five II
==============

Extended edition of the game, based on a tutorial from
[Learn Game Programming with Ruby] by [Mark Sobkowicz].

You can read the [credits](credits.txt) seperately.

<img width="868" alt="20191113-sector-five-ii" src="https://user-images.githubusercontent.com/28818/68735166-78c44600-05e5-11ea-9292-da6931007e3a.png">

Installation
============

The are two ways to run the game. One is setting up Ruby in your environment,
along all the necessary libraries. Download the source code and run the game.

The other is to go to this repository's releases page, and download a bundled
version. For now, I only provide a macOS bundle, but I can soon provide a
Windows one as well.

Running or developing on macOS
==============================

1. Install the Ruby version specified in `.ruby-version`
2. `brew install sdl2 libogg libvorbis`
3. `bundle`

Running or developing on Windows
================================

1. Download `Ruby+Devkit 2.4.9-1` from https://rubyinstaller.org/
2. Install and follow the prompts to add Ruby to your PATH, associate .rb.rbw files, and install the development tools
3. Open Command Prompt and run the following commands
4. `gem install gosu`
5. `gem install chipmunk`

Credits
=======
The starter base code comes from a tutorial from
[Learn Game Programming with Ruby]
by [Mark Sobkowicz](https://twitter.com/MarkSobkowicz).

You can read the rest of the [credits](credits.txt) seperately. It includes the
attributions for the sounds and images used in this game.

Font
====
We are using C64 Pro Mono which you can find here:  
https://style64.org/c64-truetype  
License: https://style64.org/c64-truetype/license  

Contributing
============

Please follow the [CONTRIBUTING](CONTRIBUTING.md) guide.

Contributors
============

- [petros](https://twitter.com/amiridis) ([petros.blog/games](https://petros.blog/games))

[Learn Game Programming with Ruby]: https://pragprog.com/book/msgpkids/learn-game-programming-with-ruby
[Mark Sobkowicz]: https://twitter.com/MarkSobkowicz
