class AddWelcomeMessageToCompany < ActiveRecord::Migration[5.1]
  def change
    add_column :companies, :welcome_message, :string
  end
end
