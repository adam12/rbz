# Single-file Ruby archives (`rbz`)

An experimental method of packaging a Ruby project into a single file archive,
which is extracted and run on the destination machine.

Zero dependencies outside of stdlib.

Will this work for many projects? Maybe. Will it work for all projects? Doubtful.
Will I maintain it? Unsure.

Inspired by [this][1] Ruby bug tracker issue.

## Installation

    $ gem install rbz

## Usage

Generate an archive from a folder of Ruby files. There *must* be a file in the
root of the folder called `main.rb`, which will be the entry point to the application.

    $ rbz <folder with ruby files> > my-archive.rbz

Once the archive is generated, run it with `ruby`.

    $ ruby my-archive.rbz

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

[1]: https://bugs.ruby-lang.org/issues/11028
