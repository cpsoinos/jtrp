class ActivitiesController < ApplicationController
  before_action :require_internal

  def index
    @activities = PublicActivity::Activity.includes(:owner, :trackable).order(created_at: :desc).page(params[:page]).per(25)
    @title = "Activities"
  end

end
