class AddTokenToAgreements < ActiveRecord::Migration
  def change
    add_column :agreements, :token, :string, unique: true
    Agreement.reset_column_information

    if column_exists?(:agreements, :token)
      Agreement.all.map(&:regenerate_token)
    end
  end
end
