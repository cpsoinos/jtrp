class AddFrontAndBackCheckImagesToChecks < ActiveRecord::Migration
  def change
    rename_column :checks, :check_image, :check_image_front
    add_column :checks, :check_image_back, :string
  end
end
