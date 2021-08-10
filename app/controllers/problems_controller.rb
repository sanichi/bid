class ProblemsController < ApplicationController
  load_and_authorize_resource except: ["review", "retire"]
  authorize_resource only: ["review", "retire"]

  def index
    @problems = Problem.search(@problems, params, problems_path)
    remember_last_results(@problems)
  end

  def select
    per_page = helpers.reviews_per_page(params[:per_page])
    params[:user_id] = current_user.id
    @problems = Problem.select(@problems, params, select_problems_path, per_page: per_page)
    remember_reviews(@problems)
  end

  def review
    update_review(params[:pid].to_i, params[:quality].to_i)
    @title = reviews_title
    @problem = get_next_review
    if @problem
      @review = Review.find_by(problem_id: @problem.id, user_id: current_user.id) || Review.new
    else
      redirect_to select_problems_path
    end
  end

  def retire
    forget_reviews
    redirect_to home_path
  end

  def create
    @problem.user = current_user
    if @problem.save
      redirect_to @problem
    else
      failure @problem
      render :new
    end
  end

  def update
    if @problem.update(resource_params)
      redirect_to @problem
    else
      failure @problem
      render :edit
    end
  end

  def destroy
    @problem.destroy
    redirect_to problems_path
  end

  private

  def resource_params
    params.require(:problem).permit(:bids, :category, :hand, :note, :vul)
  end

  def remember_last_results(pager)
    session[:last_problem_list] = pager.matches.pluck(:id).join(",")
    session[:next_problem_page] = pager.before_end?  ? helpers.link_to(t("pagination.next"), pager.next_page, remote: pager.remote) : nil
    session[:prev_problem_page] = pager.after_start? ? helpers.link_to(t("pagination.prev"), pager.prev_page, remote: pager.remote) : nil
  end

  def remember_reviews(pager)
    session[:reviews] = pager.matches.pluck(:id)
    session[:rvindex] = 0
    session[:repeats] = []
  end

  def forget_reviews
    session[:reviews] = nil
    session[:rvindex] = nil
    session[:repeats] = nil
  end

  def get_next_review
    pids, rids, i = okay
    return unless i
    problem = nil
    if i < pids.length
      problem = Problem.find_by(id: pids[i])
      session[:rvindex] += 1
    elsif !rids.empty?
      problem = Problem.find_by(id: rids.first)
      session[:repeats].rotate!
    end
    problem
  end

  def update_review(pid, q)
    pids, rids, i = okay
    return unless i
    return unless pids.include?(pid)
    return unless Review::QUALITY.include?(q)
    review = Review.find_or_create_by(problem_id: pid, user_id: current_user.id)
    review.step(q)
    review.save!
    if q < 3
      session[:repeats].push(pid) unless rids.include?(pid)
    else
      session[:repeats].delete(pid) if rids.include?(pid)
    end
  end

  def reviews_title
    pids, rids, i = okay
    return I18n.t("review.review") unless i
    if i < pids.length
      "%d of %d Review%s" % [session[:rvindex] + 1, pids.length, pids.length > 1 ? "s" : ""]
    elsif !rids.empty?
      "%d Repeat%s" % [rids.length, rids.length > 1 ? "s" : ""]
    else
      I18n.t("review.review")
    end
  end

  def okay
    vals = []
    return vals unless session[:reviews].is_a?(Array) && !session[:reviews].empty?
    vals.push session[:reviews]
    return vals unless session[:repeats].is_a?(Array)
    vals.push session[:repeats]
    return vals unless session[:rvindex].is_a?(Integer) && session[:rvindex] >= 0
    vals.push session[:rvindex]
    vals
  end
end
