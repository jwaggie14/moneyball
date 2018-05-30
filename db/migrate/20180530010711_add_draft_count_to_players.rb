class AddDraftCountToPlayers < ActiveRecord::Migration[5.0]
  def change
    add_column :players, :drafts_count, :integer
  end
end
