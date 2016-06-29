class PhotosController < ApplicationController
  before_filter :require_internal

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

end
