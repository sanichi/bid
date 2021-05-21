require 'rails_helper'

describe ApplicationHelper do
  describe "centre" do
    it "produces a series of progressively narrowers column widths" do
      expect(helper.centre(10,9,8,7,6,5)).to eq "col-10 col-sm-9 col-md-8 col-lg-7 col-xl-6 col-xxl-5"
    end

    it "order doesn't matter" do
      expect(helper.centre(9,8,10,5,6,7)).to eq "col-10 col-sm-9 col-md-8 col-lg-7 col-xl-6 col-xxl-5"
    end

    it "excess values are ignored" do
      expect(helper.centre(10,9,8,7,6,5,4)).to eq "col-10 col-sm-9 col-md-8 col-lg-7 col-xl-6 col-xxl-5"
    end

    it "full widths are not expressed" do
      expect(helper.centre(12,12,10,8,6,4)).to eq "col-md-10 col-lg-8 col-xl-6 col-xxl-4"
    end

    it "insufficient values are padded with full widths" do
      expect(helper.centre(9,6,3)).to eq "col-lg-9 col-xl-6 col-xxl-3"
      expect(helper.centre(6)).to eq "col-xxl-6"
    end

    it "no values gets a single column" do
      expect(helper.centre).to eq "col"
    end

    it "illegal values are ignored" do
      expect(helper.centre('a', 13, -1, 0, 'e', 'f')).to eq "col"
    end
  end
end
