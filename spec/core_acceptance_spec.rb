require "spec_helper"
require "./src/scanner.rb"

RSpec.describe "Core Acceptance criteria" do
  let(:intruder1) do
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

  let(:intruder2) do
    %w[
      ---oo---
      --oooo--
      -oooooo-
      oo-oo-oo
      oooooooo
      --o--o--
      -o-oo-o-
      o-o--o-o
    ]
  end

  context "when trying exact matches" do
    let(:scanner) do
      file = File.open("./spec/fixtures/acceptance_radar_sample", "r")
      Scanner.new(file, [intruder1, intruder2], algorithm: "exact")
    end

    it "detects intruders" do
      detections = scanner.scan

      expect(detections.length).to eq(3)
    end

    it "exposes positions for each detected intruder" do
      detections = scanner.scan

      expect(detections[0].position).to match(hash_including(x: 10, y:  3, width: 11, height: 8))
      expect(detections[1].position).to match(hash_including(x: 70, y: 25, width:  8, height: 8))
      expect(detections[2].position).to match(hash_including(x: 39, y: 33, width:  8, height: 8))
    end
  end

  context "when trying approximate matches" do
    let(:scanner) do
      file = File.open("./spec/fixtures/acceptance_radar_sample", "r")
      Scanner.new(file, [intruder1, intruder2], algorithm: "approximate")
    end

    it "detects intruders" do
      detections = scanner.scan

      expect(detections.length).to eq(5)
    end

    it "exposes positions for each detected intruder" do
      detections = scanner.scan

      expect(detections[0].position).to match(hash_including(x: 10, y:  3, width: 11, height: 8))
      expect(detections[1].position).to match(hash_including(x: 25, y: 14, width: 11, height: 8))
      expect(detections[2].position).to match(hash_including(x: 53, y:  6, width:  8, height: 8))
      expect(detections[3].position).to match(hash_including(x: 70, y: 25, width:  8, height: 8))
      expect(detections[4].position).to match(hash_including(x: 39, y: 33, width:  8, height: 8))
    end
  end
end
