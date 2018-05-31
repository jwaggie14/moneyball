class AddNameToPlayers < ActiveRecord::Migration[5.0]
  def change
      add_column :players, :name, :string
      add_column :players, :team, :string
      add_column :players, :position, :string
      add_column :players, :bye, :integer
      add_column :players, :points, :float
      add_column :players, :vor, :float
      add_column :players, :overall_rank, :integer
      add_column :players, :position_rank, :integer
      add_column :players, :adp, :float
  end
end
