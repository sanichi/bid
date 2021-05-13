require 'rails_helper'

describe Problem do
  let(:admin) { create(:user, admin: true) }
  let(:user) { create(:user, admin: false) }
  let(:data) { build(:problem) }
  let!(:problem) { create(:problem, user: admin) }

  context "admins" do
    before(:each) do
      login(admin)
      click_link t("problem.title")
    end

    context "create" do
      it "success" do
        click_link t("problem.new")
        fill_in t("problem.hand"), with: data.hand
        fill_in t("problem.bids"), with: data.bids
        select t("problem.vuls.#{data.vul}"), from: t("problem.vul")
        fill_in t("problem.category"), with: data.category
        fill_in t("problem.note"), with: data.note
        click_button t("save")

        expect(Problem.count).to eq 2
        p = Problem.order(:created_at).last
        expect(page).to have_title t("problem.show", id: p.id)
        expect(p.hand).to eq data.hand
        expect(p.bids).to eq data.bids
        expect(p.vul).to eq data.vul
        expect(p.category).to eq data.category
        expect(p.note).to eq data.note
        expect(p.user).to eq admin
        expect(p.shape).to match Hand::SHAPE
        expect(p.points).to be >= 0
      end

      context "failure" do
        it "hand" do
          click_link t("problem.new")
          fill_in t("problem.bids"), with: data.bids
          select t("problem.vuls.#{data.vul}"), from: t("problem.vul")
          fill_in t("problem.category"), with: data.category
          fill_in t("problem.note"), with: data.note
          click_button t("save")

          expect(page).to have_title t("problem.new")
          expect_error(page, t("hand.errors.under"))
          expect(Problem.count).to eq 1
        end

        it "note" do
          click_link t("problem.new")
          fill_in t("problem.hand"), with: data.hand
          fill_in t("problem.bids"), with: data.bids
          select t("problem.vuls.#{data.vul}"), from: t("problem.vul")
          fill_in t("problem.category"), with: data.category
          click_button t("save")

          expect(page).to have_title t("problem.new")
          expect_error(page, "blank")
          expect(Problem.count).to eq 1
        end
      end
    end

    context "edit" do
      it "note" do
        click_link problem.id.to_s
        click_link t("edit")

        expect(page).to have_title t("problem.edit")

        fill_in t("problem.note"), with: data.note
        click_button t("save")

        expect(page).to have_title t("problem.show", id: problem.id)
        expect(Problem.count).to eq 1
        p = Problem.order(:updated_at).last
        expect(p.note).to eq data.note
      end
    end
  end

  context "users" do
    before(:each) do
      login(user)
    end

    it "view" do
      expect(page).to_not have_css "a", text: t("problem.title")
      visit problem_path(problem)
      expect_forbidden page
    end

    it "create" do
      expect(page).to_not have_css "a", text: t("problem.new")
      visit new_problem_path
      expect_forbidden page
    end

    it "edit" do
      visit edit_problem_path(problem)
      expect_forbidden(page)
    end
  end

  context "guests" do
    before(:each) do
      visit root_path
    end

    it "view" do
      expect(page).to_not have_css "a", text: t("problem.title")
      visit problem_path(problem)
      expect_forbidden page
    end

    it "create" do
      visit new_problem_path
      expect_forbidden page
    end

    it "edit" do
      visit edit_problem_path(problem)
      expect_forbidden(page)
    end
  end
end
