class League < ApplicationRecord
  # Direct associations

  has_many   :drafts,
             :foreign_key => "draft_id",
             :dependent => :destroy

  belongs_to :user,
             :counter_cache => true

  # Indirect associations

  has_many   :players,
             :through => :drafts,
             :source => :players

  # Validations
  validates :league_name, :user_first_pick, :num_teams, presence: true
end
