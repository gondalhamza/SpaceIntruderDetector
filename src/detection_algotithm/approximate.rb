require "damerau-levenshtein"

module DetectionAlgorithm
  module Approximate
    MAX_LINE_DEVIATION = 2
    MAX_ALLOWED_DEVIATION = 3

    def self.deviation(line, sample)
      DamerauLevenshtein.distance(line, sample)
    end

    def self.matches_head?(intruder_bitmap, sample)
      deviation(intruder_bitmap.first, sample) <= MAX_LINE_DEVIATION
    end

    def self.past_allowed_deviation?(current_deviation)
      current_deviation > MAX_ALLOWED_DEVIATION
    end
  end
end
