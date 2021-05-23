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

  describe "col" do
    it "expands abbreviated column classes" do
      expect(helper.col("xs-1 sm-2 md-3 lg-4 xl-5 xxl-6")).to eq "col-1 col-sm-2 col-md-3 col-lg-4 col-xl-5 col-xxl-6"
    end

    it "expands abbreviated offset classes" do
      expect(helper.col("sx-6 ms-5 dm-4 gl-3 lx-2 lxx-1")).to eq "offset-6 offset-sm-5 offset-md-4 offset-lg-3 offset-xl-2 offset-xxl-1"
    end

    it "handles special abbreviations" do
      expect(helper.col("0 5 10 md-11 gl-12")).to eq "col-0 col-5 col-10 col-md-11 offset-lg-12"
    end

    it "handles special cases" do
      expect(helper.col(nil)).to eq ""
      expect(helper.col("")).to eq ""
      expect(helper.col(false)).to eq ""
      expect(helper.col(true)).to eq "col-12"
    end

    it "leaves everything else untouched" do
      expect(helper.col("col-3 col-md-7 offset-lg-1 abcdefg")).to eq "col-3 col-md-7 offset-lg-1 abcdefg"
      expect(helper.col(" colmd3 offsetlg5 COL-3")).to eq " colmd3 offsetlg5 COL-3"
    end
  end
end
