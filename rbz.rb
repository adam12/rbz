#!/usr/bin/env ruby

require "rubygems/package"
require "stringio"

io = StringIO.new

Gem::Package::TarWriter.new(io) do |writer|
  Dir.chdir(ARGV[0]) do
    Dir.children(Dir.pwd).each do |e|
      next if File.directory?(e)
      writer.add_file(e, "0644") { |fio| fio.write File.read(e) }
    end
  end
end

puts DATA.read
puts
puts "__END__"
puts [io.string].pack("m")

__END__

require "tmpdir"
require "rubygems/package"
require "stringio"

Dir.mktmpdir("rbz") do |dir|
  Dir.chdir(dir) do
    tar = StringIO.new(DATA.read.unpack1("m"))
    Gem::Package::TarReader.new(tar) do |reader|
      reader.each do |entry|
        next if entry.full_name.start_with?("._")
        next if entry.full_name.start_with?("PaxHeader")

        File.write(entry.full_name, entry.read)
      end
    end

    exec "ruby", "main.rb"
  end
end
