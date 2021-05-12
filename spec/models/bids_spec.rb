require 'rails_helper'

describe Bids do
  describe "valid" do
    it "perfect" do
      [
        "P",
        "1H",
        "1N",
        "P|P|2C|P|2D",
        "P|1C|1S|2D|3S|P",
      ].each do |str|
        b = Bids.new(str)
        expect(b).to_not be_error
        expect(b.to_s).to eq str
      end
    end

    it "examples" do
      Bids::EXAMPLES.each do |str|
        b = Bids.new(str)
        expect(b).to_not be_error
        expect(b.to_s).to eq str
      end
    end

    it "allowed" do
      {
        "P" => ["p", " p ", "|p|"],
        "1H" => ["1h", "\n1h\t", "|1h|"],
        "1N" => ["1n", "1nt", "1Nt"],
        "1H|1S" => ["1h1s", "1h 1S", "1H\n1s"],
        "1C|X" => ["1cx", "1C dbl", "1c db"],
        "1N|X|XX" => ["1n|x|xx", "1nx xx", "1N dbl rd", "1n db rdl", "1ndbrdl"],
      }.each_pair do |str,inputs|
        inputs.each do |input|
          t = Bids.new(input)
          expect(t).to_not be_error
          expect(t.to_s).to eq str
        end
      end
    end
  end

  describe "invalid" do
    it "bid" do
      [
        "1H|1H",
        "2N|P|2C",
      ].each do |str|
        b = Bids.new(str)
        expect(b).to be_error
        expect(b.error).to eq t("bids.errors.level")
      end
    end

    it "double" do
      [
        "X",
        "P|X",
        "1D|P|X",
        "1D|X|X",
        "1D|X|XX|X",
        "1D|X|XX|P|X",
      ].each do |str|
        b = Bids.new(str)
        expect(b).to be_error
        expect(b.error).to eq t("bids.errors.double")
      end
    end

    it "redouble" do
      [
        "XX",
        "P|XX",
        "1D|X|P|XX",
        "1D|X|XX|XX",
        "1D|X|XX|P|XX",
      ].each do |str|
        b = Bids.new(str)
        expect(b).to be_error
        expect(b.error).to eq t("bids.errors.redouble")
      end
    end

    it "pass" do
      [
        "P|P|P|P",
        "P|P|P|P|1N",
        "1C|P|P|P|P|1D",
      ].each do |str|
        b = Bids.new(str)
        expect(b).to be_error
        expect(b.error).to eq t("bids.errors.pass")
      end
    end

    it "none" do
      [
        "",
        "|",
        "||",
      ].each do |str|
        b = Bids.new(str)
        expect(b).to be_error
        expect(b.error).to eq t("bids.errors.none")
      end
    end
  end
end
