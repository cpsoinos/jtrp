class PhotosController < ApplicationController
  before_filter :require_internal
  before_filter :find_proposal, only: :batch_create

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
    binding.pry
    PhotoCreator.new(@proposal).create_multiple(params)
    redirect_to account_job_proposal_sort_items_path(@proposal.account, @proposal.job, @proposal)
  end

  protected

  def photo_params
    params.require(:photo).permit(:photo, :photo_type)
  end

end
