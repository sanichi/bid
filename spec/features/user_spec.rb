require 'rails_helper'

describe User do
  let!(:admin) { create(:user, admin: true) }
  let!(:user)  { create(:user, admin: false) }
  let(:data)   { build(:user, admin: false) }

  context "admins" do
    before(:each) do
      login admin
      click_link t("user.users")
    end

    it "user counts" do
      expect(page).to have_title t("user.users")
      expect(User.where(admin: false).count).to eq 1
      expect(User.where(admin: true).count).to eq 1
    end

    it "create user" do
      click_link t("user.new")

      fill_in t("user.name"), with: data.name
      fill_in t("user.email"), with: data.email
      fill_in t("user.password"), with: data.password
      click_button t("save")

      expect(page).to have_title data.name
      expect(User.where(admin: false).count).to eq 2
      u = User.find_by(name: data.name)
      expect(u.password).to be_nil
      expect(u.password_digest).to be_present
      expect(u.email).to eq data.email.downcase
      expect(u.admin).to eq false

      click_link t("session.sign_out")

      expect(page).to have_title t("title")

      click_link t("session.sign_in")
      fill_in t("user.email"), with: u.email
      fill_in t("user.password"), with: data.password
      click_button t("session.sign_in")

      expect(page).to have_title data.name
    end

    it "edit user" do
      click_link user.email
      click_link t("edit")
      fill_in t("user.name"), with: data.name
      click_button t("save")

      expect(page).to have_title data.name
      expect(User.where(admin: false, name: data.name).count).to eq 1
    end

    it "delete user" do
      click_link user.email
      click_link t("edit")
      click_link t("delete")

      expect(page).to have_title t("user.users")
      expect(User.where(admin: false).count).to eq 0
      expect(User.where(admin: true).count).to eq 1
    end
  end

  context "users" do
    before(:each) do
      login user
    end

    it "can log out" do
      click_link t("session.sign_out")

      expect(page).to have_title t("title")
    end

    it "can't list users" do
      expect(page).to_not have_css "a", text: t("user.users")

      visit users_path

      expect_forbidden page
    end

    it "can't create users" do
      expect(page).to_not have_css "a", text: t("user.new")

      visit new_user_path

      expect_forbidden page
    end
  end

  context "guests" do
    before(:each) do
      visit root_path
    end

    it "can login" do
      click_link t("session.sign_in")

      expect(page).to have_title t("session.sign_in")
    end

    it "can't list users" do
      expect(page).to_not have_css "a", text: t("user.users")

      visit users_path

      expect_forbidden page
    end

    it "can't create users" do
      expect(page).to_not have_css "a", text: t("user.new")

      visit new_user_path

      expect_forbidden page
    end
  end
end
