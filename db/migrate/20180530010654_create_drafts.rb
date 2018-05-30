class CreateDrafts < ActiveRecord::Migration
  def change
    create_table :drafts do |t|
      t.integer :draft_id
      t.integer :players_id
      t.integer :pick_num

      t.timestamps

    end
  end
end
