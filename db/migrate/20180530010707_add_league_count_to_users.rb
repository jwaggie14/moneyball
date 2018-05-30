class AddLeagueCountToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :leagues_count, :integer
  end
end
