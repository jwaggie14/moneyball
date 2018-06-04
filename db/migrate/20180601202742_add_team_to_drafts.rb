class AddTeamToDrafts < ActiveRecord::Migration[5.0]
  def change
    add_column :drafts, :team, :integer
  end
end
