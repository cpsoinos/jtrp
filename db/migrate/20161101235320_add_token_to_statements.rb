class AddTokenToStatements < ActiveRecord::Migration
  def change
    add_column :statements, :token, :string, unique: true
    Statement.reset_column_information

    if column_exists?(:statements, :token)
      Statement.all.map(&:regenerate_token)
    end
  end
end
