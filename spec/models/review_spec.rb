require 'rails_helper'

describe Review do
  describe "step" do
    it "steady improver" do
      t = Review.new

      t.step(0)
      expect(t.repetitions).to eq 0
      expect(t.interval).to eq 1
      expect(t.factor).to eq 2.5
      expect(t.attempts).to eq 1

      t.step(1)
      expect(t.repetitions).to eq 0
      expect(t.interval).to eq 1
      expect(t.factor).to eq 2.5
      expect(t.attempts).to eq 2

      t.step(2)
      expect(t.repetitions).to eq 0
      expect(t.interval).to eq 1
      expect(t.factor).to eq 2.5
      expect(t.attempts).to eq 3

      t.step(3)
      expect(t.repetitions).to eq 1
      expect(t.interval).to eq 1
      expect(t.factor).to eq 2.36
      expect(t.attempts).to eq 4

      t.step(4)
      expect(t.repetitions).to eq 2
      expect(t.interval).to eq 6
      expect(t.factor).to eq 2.36
      expect(t.attempts).to eq 5

      t.step(5)
      expect(t.repetitions).to eq 3
      expect(t.interval).to eq 15
      expect(t.factor).to eq 2.46
      expect(t.attempts).to eq 6
    end
  end
end
