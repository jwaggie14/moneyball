class RemovePositionRankFromPlayers < ActiveRecord::Migration[5.0]
  def change
    remove_column :players, :position_rank
    add_column :players, :position_rank, :integer
  end
end
