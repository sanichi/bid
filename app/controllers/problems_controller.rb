class ProblemsController < ApplicationController
  load_and_authorize_resource

  def index
    @problems = Problem.search(@problems, params, problems_path, per_page: 10)
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
    params.require(:problem).permit(:bids, :draft, :hand, :note, :vul)
  end
end
