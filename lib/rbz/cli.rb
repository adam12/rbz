require "rubygems/package"
require "stringio"
require "zlib"
require "optionparser"
require "erb"

module Rbz
  module CLI
    def self.run(argv)
      options = {
        main: "main.rb",
        output: $stdout
      }

      parser = OptionParser.new do |parser|
        parser.accept(File) do |path|
          abort "Error: #{path} already exists" if File.exist?(path)
          f = File.open(path, mode: "w")
          File.chmod(0o755, path)
          f
        end

        parser.banner = "Usage: rbz [options] folder"
        parser.on("-c", "--compile", "Store compiled Ruby iseq")
        parser.on("-m FILE", "--main FILE", "Main entrypoint (relative to folder, default: main.rb)")
        parser.on("-o FILE", "--output FILE", File, "Output path (default: stdout)")
        parser.on("--verbose", "Verbose mode")
      end
      parser.parse!(into: options)

      source = ARGV[0] or abort(parser.to_s)
      output = options[:output]
      io = StringIO.new

      Gem::Package::TarWriter.new(io) do |writer|
        Dir.chdir(source) do
          Dir.glob("**/*").each do |e|
            next if File.directory?(e)
            mode = File.lstat(e).mode

            if options[:compile] && File.extname(e) == ".rb"
              contents = RubyVM::InstructionSequence.compile_file(e).to_binary
              $stderr.puts "a #{e}.iseq" if options[:verbose] # standard:disable Style/StderrPuts
              writer.add_file(e + ".iseq", mode) { |fio| fio.write(contents) }
            end

            $stderr.puts "a #{e}" if options[:verbose] # standard:disable Style/StderrPuts
            writer.add_file(e, mode) { |fio| fio.write(File.binread(e)) }
          end
        end
      end

      output.puts ERB.new(Rbz.templates.join("bin.rb.erb").read, trim_mode: "-").result(binding)
      output.puts
      output.puts "__END__"
      output.puts [Zlib::Deflate.deflate(io.string)].pack("m")
    end
  end
end
