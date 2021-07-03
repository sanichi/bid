require 'rails_helper'

describe Review do
  let(:user1)  { create(:user, admin: false) }
  let(:user2)  { create(:user, admin: false) }

  let!(:problem1) { create(:problem) }
  let!(:problem2) { create(:problem) }
  let!(:problem3) { create(:problem) }
  let!(:problem4) { create(:problem) }

  it "session", js: true do
    expect(Problem.count).to eq 4
    expect(Review.count).to eq 0

    login user1
    click_link "4"
    expect(page).to have_title t("review.title")

    click_link t("review.review")
    expect(page).to have_title t("review.review")
    expect(page).to have_css("h3", text: "1 of 4 Reviews")

    click_button t("review.reveal")
    click_button t("review.btn.text")[4]
    expect(Review.count).to eq 1
    review = problem1.reviews.find_by(user_id: user1.id)
    expect(review).to_not be_nil
    expect(review.attempts).to eq 1
    expect(review.repetitions).to eq 1
    expect(review.interval).to eq 1
    expect(page).to have_css("h3", text: "2 of 4 Reviews")

    click_button t("review.reveal")
    click_button t("review.btn.text")[0]
    expect(Review.count).to eq 2
    review = problem2.reviews.find_by(user_id: user1.id)
    expect(review).to_not be_nil
    expect(review.attempts).to eq 1
    expect(review.repetitions).to eq 0
    expect(review.interval).to eq 1
    expect(page).to have_css("h3", text: "3 of 4 Reviews")

    click_button t("review.reveal")
    click_button t("review.btn.text")[5]
    expect(Review.count).to eq 3
    review = problem3.reviews.find_by(user_id: user1.id)
    expect(review).to_not be_nil
    expect(review.attempts).to eq 1
    expect(review.repetitions).to eq 1
    expect(review.interval).to eq 1
    expect(page).to have_css("h3", text: "4 of 4 Reviews")

    click_button t("review.reveal")
    click_button t("review.btn.text")[0]
    expect(Review.count).to eq 4
    review = problem4.reviews.find_by(user_id: user1.id)
    expect(review).to_not be_nil
    expect(review.attempts).to eq 1
    expect(review.repetitions).to eq 0
    expect(review.interval).to eq 1
    expect(page).to have_css("h3", text: "2 Repeats")

    click_button t("review.reveal")
    click_button t("review.btn.text")[0]
    expect(Review.count).to eq 4
    review = problem2.reviews.find_by(user_id: user1.id)
    expect(review).to_not be_nil
    expect(review.attempts).to eq 2
    expect(review.repetitions).to eq 0
    expect(review.interval).to eq 1
    expect(page).to have_css("h3", text: "2 Repeats")

    click_button t("review.reveal")
    click_button t("review.btn.text")[3]
    expect(Review.count).to eq 4
    review = problem4.reviews.find_by(user_id: user1.id)
    expect(review).to_not be_nil
    expect(review.attempts).to eq 2
    expect(review.repetitions).to eq 1
    expect(review.interval).to eq 1
    expect(page).to have_css("h3", text: "1 Repeat")

    click_button t("review.reveal")
    click_button t("review.btn.text")[3]
    expect(Review.count).to eq 4
    review = problem2.reviews.find_by(user_id: user1.id)
    expect(review).to_not be_nil
    expect(review.attempts).to eq 3
    expect(review.repetitions).to eq 1
    expect(review.interval).to eq 1
    expect(page).to have_title t("review.title")

    find(:xpath, "//a/img[@alt='logo']/..").click
    within :xpath, "//table/tbody/tr[td[.='#{t("review.summary.attempts")}']]" do
      expect(page).to have_css("th", text: "7")
    end
    within :xpath, "//table/tbody/tr[td[.='#{t("review.summary.day")}']]" do
      expect(page).to have_css("th", text: "4")
    end
    within :xpath, "//table/tbody/tr[td[.='#{t("review.summary.done")}']]" do
      expect(page).to have_css("th", text: "4")
    end
    within :xpath, "//table/tbody/tr[td[.='#{t("review.summary.due")}']]" do
      expect(page).to have_css("th", text: "0")
    end
    within :xpath, "//table/tbody/tr[td[.='#{t("review.summary.new")}']]" do
      expect(page).to have_css("th", text: "0")
    end
    within :xpath, "//table/tbody/tr[td[.='#{t("review.summary.total")}']]" do
      expect(page).to have_css("th", text: "4")
    end

    logout
    login user2
    click_link t("review.title")
    select t("review.types.new"), from: t("review.type")
    click_link t("review.review")
    expect(page).to have_title t("review.review")
    expect(page).to have_css("h3", text: "1 of 4 Reviews")

    click_button t("review.reveal")
    click_button t("review.btn.text")[5]
    expect(Review.count).to eq 5
    review = problem1.reviews.find_by(user_id: user2.id)
    expect(review).to_not be_nil
    expect(review.attempts).to eq 1
    expect(review.repetitions).to eq 1
    expect(review.interval).to eq 1
    expect(page).to have_css("h3", text: "2 of 4 Reviews")

    click_button t("review.reveal")
    click_button t("review.btn.text")[5]
    expect(Review.count).to eq 6
    review = problem2.reviews.find_by(user_id: user2.id)
    expect(review).to_not be_nil
    expect(review.attempts).to eq 1
    expect(review.repetitions).to eq 1
    expect(review.interval).to eq 1
    expect(page).to have_css("h3", text: "3 of 4 Reviews")

    click_button t("review.reveal")
    click_button t("review.btn.text")[5]
    expect(Review.count).to eq 7
    review = problem3.reviews.find_by(user_id: user2.id)
    expect(review).to_not be_nil
    expect(review.attempts).to eq 1
    expect(review.repetitions).to eq 1
    expect(review.interval).to eq 1
    expect(page).to have_css("h3", text: "4 of 4 Reviews")

    click_button t("review.reveal")
    click_button t("review.btn.text")[5]
    expect(Review.count).to eq 8
    review = problem4.reviews.find_by(user_id: user2.id)
    expect(review).to_not be_nil
    expect(review.attempts).to eq 1
    expect(review.repetitions).to eq 1
    expect(review.interval).to eq 1
    expect(page).to have_title t("review.title")

    find(:xpath, "//a/img[@alt='logo']/..").click
    expect(page).to have_title user2.name
    within :xpath, "//table/tbody/tr[td[.='#{t("review.summary.attempts")}']]" do
      expect(page).to have_css("th", text: "4")
    end
    within :xpath, "//table/tbody/tr[td[.='#{t("review.summary.day")}']]" do
      expect(page).to have_css("th", text: "4")
    end
    within :xpath, "//table/tbody/tr[td[.='#{t("review.summary.done")}']]" do
      expect(page).to have_css("th", text: "4")
    end
    within :xpath, "//table/tbody/tr[td[.='#{t("review.summary.due")}']]" do
      expect(page).to have_css("th", text: "0")
    end
    within :xpath, "//table/tbody/tr[td[.='#{t("review.summary.new")}']]" do
      expect(page).to have_css("th", text: "0")
    end
    within :xpath, "//table/tbody/tr[td[.='#{t("review.summary.total")}']]" do
      expect(page).to have_css("th", text: "4")
    end
  end
end