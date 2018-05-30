class CreateLeagues < ActiveRecord::Migration
  def change
    create_table :leagues do |t|
      t.integer :user_id
      t.integer :num_teams
      t.string :scoring
      t.string :user_first_pick
      t.string :league_name

      t.timestamps

    end
  end
end
