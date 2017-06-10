class PhotosController < ApplicationController
  before_action :require_internal
  before_action :find_proposal, only: :batch_create

  def create
    @photo = Photo.new(photo_params)
    if @photo.save
      flash[:notice] = "Photo saved!"
      redirect_to categories_path
    else
      flash[:warning] = "Photo could not be saved."
      redirect_to :back
    end
  end

  def destroy
    @photo = Photo.find(params[:id])
    if @photo.destroy
      respond_to do |format|
        format.js do
          render 'items/remove_photo'
        end
        format.html
      end
    end
  end

  def batch_create
    PhotoCreator.new(@proposal).create_multiple(params)
    respond_to do |format|
      format.html do
        redirect_to account_job_proposal_sort_photos_path(@proposal.account, @proposal.job, @proposal)
      end
      format.js do
        @message = "Photos uploaded! Proceed to the next step..."
      end
    end
  end

  def sort
    params[:photo].each_with_index do |id, index|
      Photo.where(id: id).update_all(position: index+1)
    end
    render nothing: true
  end

  protected

  def photo_params
    params.require(:photo).permit(:photo, :photo_type)
  end

end
