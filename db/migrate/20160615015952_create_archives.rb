class CreateArchives < ActiveRecord::Migration
  def change
    create_table :archives do |t|
      t.string :archive
    end
  end
end
