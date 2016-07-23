class AddInitialDescriptionToItems < ActiveRecord::Migration
  def change
    add_column :items, :initial_description, :string
    Item.reset_column_information

    Item.all.each do |item|
      item.update_attribute("initial_description", item.description) if item.initial_description.blank?
    end
  end
end
