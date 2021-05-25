module DetectionAlgorithm
  module Exact
    def self.deviation(line, sample)
      line != sample ? 1 : 0
    end

    def self.matches_head?(intruder_bitmap, sample)
      intruder_bitmap.first == sample
    end

    def self.past_allowed_deviation?(current_deviation)
      current_deviation > 0
    end
  end
end
