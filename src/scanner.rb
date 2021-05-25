require_relative "./detector.rb"
require_relative "./detection_algotithm/exact.rb"
require_relative "./detection_algotithm/approximate.rb"

class Scanner
  def initialize(input, intruders, algorithm: "approximate")
    @input = input
    @intruders = intruders
    @algorithm = algorithm
  end

  def scan
    @input.each_with_index do |line, line_number|
      detectors.each do |detector|
        detector.push(line, line_number)
      end
    end

    @detectors.map(&:positive_detections).flatten
  end

  private

  def detectors
    @detectors ||= begin
      algorithm = case @algorithm
                  when "exact" then DetectionAlgorithm::Exact
                  when "approximate" then DetectionAlgorithm::Approximate
                  end
      @intruders.map { |it| Detector.new(it, algorithm) }
    end
  end
end
