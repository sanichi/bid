class ProblemsController < ApplicationController
  load_and_authorize_resource

  def index
    per_page = helpers.problems_per_page(params[:per_page])
    @problems = Problem.search(@problems, params, problems_path, per_page: per_page)
    remember_last_results(@problems)
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
end
