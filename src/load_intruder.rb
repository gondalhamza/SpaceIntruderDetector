class IntruderLoader
  START_END_MARKER = "~~~~".freeze

  def self.call(filename)
    new(filename).call
  end

  def initialize(filename)
    @filename = filename
  end

  def call
    loading_intruder = false
    bitmap = nil
    intruders = []

    File.open(@filename, "r") do |f|
      f.each_line do |line|
        line.strip!

        if !loading_intruder
          next unless line == START_END_MARKER

          loading_intruder = true
          bitmap = []
        elsif line != START_END_MARKER
          bitmap << line
        else
          intruders << bitmap
          loading_intruder = false
          bitmap = nil
        end
      end
    end

    intruders
  end
end
