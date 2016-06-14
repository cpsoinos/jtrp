class CreateSystemInfo < ActiveRecord::Migration
  def change
    create_table :system_infos do |t|
      t.integer :last_account_number, default: 10
    end
  end
end
