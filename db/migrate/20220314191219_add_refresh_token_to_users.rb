class AddRefreshTokenToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :refresh_token, :string
    add_index :users, :refresh_token
  end
end
