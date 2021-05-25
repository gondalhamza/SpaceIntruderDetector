require 'optparse'
require_relative "./load_intruder.rb"
require_relative "./scanner.rb"

require 'pry'

Options = Struct.new(:scan_file, :intruders_file, :algorithm, keyword_init: true)

class Parser
  def self.parse(cli_args)
    args = Options.new(scan_file: cli_args[0],
                       intruders_file: "./lib/intruders",
                       algorithm: "exact")

    opt_parser = OptionParser.new do |opts|
      opts.banner = "Usage: skyscanner scan_file [options]"

      opts.on("-iINTRUDERS", "--intruders=INTRUDERS",
              "file where to load the intruders from. Defaults to a set of known ones.") do |filename|
        args.intruders_file = filename
      end

      opts.on("-aALGORITHM", "--algorithm=ALGORITHM",
              "selects the matching algorithm: exact, approximate. Defaults to exact.") do |algorithm|
        args.algorithm = algorithm
      end

      opts.on("-h", "--help", "prints help") do
        puts opts
        exit
      end
    end

    opt_parser.parse!(cli_args)
    return args
  end
end

class CLI
  def self.run(arguments)
    new.run(arguments)
  end

  def run(arguments)
    begin
      options = Parser.parse(arguments)

      scan_file  = File.open(options.scan_file, "r")
      intruders  = IntruderLoader.call(options.intruders_file)
      detections = Scanner.new(scan_file, intruders, algorithm: options.algorithm).scan

      scan_file.rewind

      scan_file.each_with_index do |line, line_idx|
        line.split("").each_with_index do |char, column_idx|
          detection = detections.find { |it| within?(it, column_idx, line_idx) }
          if detection
            printf "\e[31m#{char}\e[0m"
          else
            printf  char
          end
        end
      end
    end
  rescue => e
    puts "Error --> #{e}"
  end

  private

  def within?(detection, x, y)
    x >= detection.position[:x] &&
      x <= detection.position[:x] + detection.position[:width] - 1 &&
      y >= detection.position[:y] &&
      y <= detection.position[:y] + detection.position[:height] - 1
  end
end
