class AddDraftCountToLeagues < ActiveRecord::Migration[5.0]
  def change
    add_column :leagues, :drafts_count, :integer
  end
end
