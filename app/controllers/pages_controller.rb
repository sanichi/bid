class PagesController < ApplicationController
  # see https://github.com/CanCanCommunity/cancancan/wiki/Non-RESTful-Controllers
  authorize_resource class: false

  def env
    vers = ActiveRecord::Base.connection.execute('select version();').values[0][0] rescue "oops"
    @postgres_version = vers.match(/PostgreSQL (1[4-8]\.\d+)/)? $1 : "not found"
    @host = ENV["HOSTNAME"] || `hostname`.chop.sub(".local", "")
  end

  def home
    unless current_user.guest?
      @name = current_user.name
      done = Review.where(user_id: current_user.id)
      @total = Problem.count
      @done = done.count
      @new = @total - @done
      @due = done.where("due <= ?", Time.now).count
      @day = done.where("due > ?", Time.now).where("due <= ?", Time.now + 1.day).count
      @attempts = done.pluck(:attempts).sum
    end
  end

  def links
    @links = Note.note_links
  end
end
