require "spec_helper"
require "./src/detection.rb"
require "./src/detection_algotithm/exact.rb"
require "./src/detection_algotithm/approximate.rb"

RSpec.describe Detection do
  let(:intruder) do
    %w[ --o-----o--
        ---o---o---
        --ooooooo--
        -oo-ooo-oo-
        ooooooooooo
        o-ooooooo-o
        o-o-----o-o
        ---oo-oo--- ]
  end

  let(:column) { 2 }
  let(:line) { 3 }
  let(:algorithm) { DetectionAlgorithm::Exact }
  subject(:detection) { described_class.new(intruder, algorithm, column, line) }

  context "with clean samples matching the intruder" do
    let(:samples) do
      %w[--o-----o--
         ---o---o---
         --ooooooo--
         -oo-ooo-oo-
         ooooooooooo
         o-ooooooo-o
         o-o-----o-o
         ---oo-oo---]
    end

    it "becomes a positive detection" do
      samples.each { |sample| detection.push(sample, column) }

      expect(detection).not_to be_invalid
      expect(detection).to be_positive
    end
  end

  context "with samples that don't match the intruder" do
    let(:samples) do
      %w[--o-----o--
         o--o---o--o
         --ooooooo--
         -ooooooooo-
         ooooooooooo
         o-ooooooo-o
         o-ooooooo-o
         ---ooooo---]
    end

    it "becomes a non-positive detection" do
      samples.each { |sample| detection.push(sample, column) }

      expect(detection).to be_invalid
      expect(detection).not_to be_positive
    end
  end

  context "feeding the detection with samples from different places" do
    let(:samples_on_other_column) do
      %w[--o-----o--
         oo-o-o-o-oo
         o-ooooooo-o
         -ooooooooo-
         oooooo--ooo
         o-oo----o-o
         o-oooo-oo-o
         ---oo-oooo-]
    end

    let(:samples_on_same_column) do
      %w[--o-----o--
         ---o---o---
         --ooooooo--
         -oo-ooo-oo-
         ooooooooooo
         o-ooooooo-o
         o-o-----o-o
         ---oo-oo---]
    end

    it "ignores samples that don't start on the same column as the detection" do
      sample_pairs = samples_on_same_column.zip(samples_on_other_column)

      sample_pairs.each do |(good_sample, bad_sample)|
        detection.push(good_sample, column)
        detection.push(bad_sample, column + 1)
      end

      expect(detection).not_to be_invalid
      expect(detection).to be_positive
    end
  end

  context "with inexact matches" do
    let(:algorithm) { DetectionAlgorithm::Approximate }

    context "with minimal difference" do
      let(:samples) do
        %w[---o---o---
           ---o---o---
           --ooooooo--
           -oo-ooo-oo-
           ooooooooooo
           o-ooooooo-o
           o-o-----o-o
           ---oo-oo---]
      end

      it "still detects an intruder" do
        samples.each { |sample| detection.push(sample, column) }

        expect(detection).not_to be_invalid
        expect(detection).to be_positive
      end
    end

    context "with large number of differences" do
      let(:samples) do
        %w[---o---o---
           --o-----o--
           --ooooooo--
           -ooo-o-ooo-
           ooooooooooo
           oo-ooooo-oo
           o-o-----o-o
           --o-o-o-o--]
      end

      it "doen't detects an intruder" do
        samples.each { |sample| detection.push(sample, column) }

        expect(detection).to be_invalid
        expect(detection).not_to be_positive
      end
    end
  end
end
