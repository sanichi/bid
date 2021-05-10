require 'rails_helper'

describe Hand do
  describe "valid" do
    it "perfect" do
      [
        "AKQJ|AKQJ|AKQ|AK",
        "32|32|65432|5432",
        "T73|K42|A543|T42",
      ].each do |str|
        h = Hand.new(str)
        expect(h).to_not be_error
        expect(h.to_s).to eq str
      end
    end

    it "allowed" do
      {
        "AQ9|KJT|T987|765" => ["AQ9KJTT987765", "aq9kjtt987765"],
        "842|AJT9|T63|KQJ" => ["842 Ajt9 T63 kqj", "842/Ajt9/T63/kqj"],
        "|JT875||AQJT9642" => ["-Jt875--Aqjt9642", "_Jt875!!Aqjt9642"],
        "KQJT9|||98765432" => ["kqjt9___98765432", "KqJt9 ; ; ; 98765432"],
        "AKQJT98765432|||" => ["akqjt9876 5432", " akqjt\n987\t65432 | | | "],
        "|AKQJT98765432||" => [".akqjt9876543 2"],
        "||AKQJT98765432|" => ["-.akqjt9 8765432"],
        "|||AKQJT98765432" => ["xxzak qjt98765432"],
      }.each_pair do |str,inputs|
        inputs.each do |input|
          h = Hand.new(input)
          expect(h).to_not be_error
          expect(h.to_s).to eq str
        end
      end
    end

    it "spades" do
      {
        "AQ7|J53|AQJ6|T42" => ["A", "Q", "7"],
        "|KJ963|T98|AKQ95" => [],
        "AKQJT98765432|||" => ["A", "K", "Q", "J", "T", "9", "8", "7", "6", "5", "4", "3", "2"],
      }.each_pair do |str,cards|
        h = Hand.new(str)
        expect(h).to_not be_error
        expect(h.spades).to eq cards
      end
    end

    it "hearts" do
      {
        "T8542|9876|74|86" => ["9", "8", "7", "6"],
        "AKQT42||K532|J73" => [],
        "|AKQJT98765432||" => ["A", "K", "Q", "J", "T", "9", "8", "7", "6", "5", "4", "3", "2"],
      }.each_pair do |str,cards|
        h = Hand.new(str)
        expect(h).to_not be_error
        expect(h.hearts).to eq cards
      end
    end

    it "diamonds" do
      {
        "J9|84|AQJT2|AT73" => ["A", "Q", "J", "T", "2"],
        "AQT62|T652||J952" => [],
        "||AKQJT98765432|" => ["A", "K", "Q", "J", "T", "9", "8", "7", "6", "5", "4", "3", "2"],
      }.each_pair do |str,cards|
        h = Hand.new(str)
        expect(h).to_not be_error
        expect(h.diamonds).to eq cards
      end
    end

    it "clubs" do
      {
        "AKJ43|732|AQ86|5" => ["5"],
        "Q72|AKQ4|AK6432|" => [],
        "|||AKQJT98765432" => ["A", "K", "Q", "J", "T", "9", "8", "7", "6", "5", "4", "3", "2"],
      }.each_pair do |str,cards|
        h = Hand.new(str)
        expect(h).to_not be_error
        expect(h.clubs).to eq cards
      end
    end
  end

  describe "invalid" do
    it "over" do
      [
        "T73|K42|A543|T942",
        "AKQJT98765432A",
      ].each do |str|
        h = Hand.new(str)
        expect(h).to be_error
        expect(h.error).to eq t("hand.errors.over")
      end
    end

    it "under" do
      [
        "T73|K42|A54|T94",
        "AKQJT9876543",
        "AAAA",
        "",
      ].each do |str|
        h = Hand.new(str)
        expect(h).to be_error
        expect(h.error).to eq t("hand.errors.under")
      end
    end

    it "suits" do
      [
        "2345|6789|TJ|QKA",
        "jt98 jt98 jt98 jt98 jt98",
      ].each do |str|
        h = Hand.new(str)
        expect(h).to be_error
        expect(h.error).to eq t("hand.errors.suits")
      end
    end
  end
end