require "spec_helper"
require "./src/detector.rb"
require "./src/detection_algotithm/exact.rb"

RSpec.describe Detector do
  let(:intruder) do
    %w[
      --o-----o--
      ---o---o---
      --ooooooo--
      -oo-ooo-oo-
      ooooooooooo
      o-ooooooo-o
      o-o-----o-o
      ---oo-oo---
    ]
  end

  subject(:detector) { described_class.new(intruder, DetectionAlgorithm::Exact) }

  context "" do
    let(:sample_lines) do
      %w[---------------------------------
         ---------------------------------
         -------------o-----o-------------
         --------------o---o--------------
         -------------ooooooo-------------
         ------------oo-ooo-oo------------
         -----------ooooooooooo-----------
         -----------o-ooooooo-o-----------
         -----------o-o-----o-o-----------
         --------------oo-oo--------------
         ---------------------------------
         ---------------------------------]
    end

    it "detects the presence of the given intruder" do
      sample_lines.each_with_index { |line, idx| detector.push(line, idx) }
      expect(detector.positive_detections.length).to eq(1)
    end
  end

  context "" do
    let(:sample_lines) do
      %w[--o-----o------------------------
         ---o---o-------------------------
         --ooooooo----o-----o-------------
         -oo-ooo-oo----o---o--------------
         ooooooooooo--ooooooo----o-----o--
         o-ooooooo-o-oo-ooo-oo----o---o---
         o-o-----o-oooooooooooo--ooooooo--
         ---oo-oo---o-ooooooo-o-oo-ooo-oo-
         -----------o-o-----o-oooooooooooo
         --------------oo-oo---o-ooooooo-o
         ----------------------o-o-----o-o
         -------------------------oo-oo---]
    end


    it "returns as many detections as there are intruders on the sample" do
      sample_lines.each_with_index { |line, idx| detector.push(line, idx) }
      expect(detector.positive_detections.length).to eq(3)
    end
  end

  context "" do
    let(:sample_lines) do
      # NOTE: this pattern bellow is not random, third line is supposed to trigger
      #       3 potential starts of detections because you can sample that line
      #       includes 3 "--o-----o--" patterns.
      %w[-------ooooooooooooooooooo-------
         -------ooooooooooooooooooo-------
         -------o-----o-----o-----o-------
         -------o------o---o------o-------
         -------o-----ooooooo-----o-------
         -------o----oo-ooo-oo----o-------
         -------o---ooooooooooo---o-------
         -------o---o-ooooooo-o---o-------
         -------o---o-o-----o-o---o-------
         -------o------oo-oo------o-------
         -------ooooooooooooooooooo-------
         -------ooooooooooooooooooo-------]
    end


    it "discards false positives, only valid detections are returned" do
      sample_lines.each_with_index { |line, idx| detector.push(line, idx) }
      expect(detector.positive_detections.length).to eq(1)
    end
  end
end
