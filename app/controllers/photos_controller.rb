class PhotosController < ApplicationController
  before_filter :require_internal

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

  protected

  def photo_params
    params.require(:photo).permit(:photo, :photo_type)
  end

end
