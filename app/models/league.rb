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
  validates :user_first_pick, :num_teams, numericality: { only_integer:true }
  validates :num_teams, numericality: { greater_than: 1, message: " must be at least 2." }
  validates :num_teams, numericality: { less_than: 17, message: " must be at most 16." }
  validates :user_first_pick, numericality: { greater_than: 0, message: " can't be below 1..." }
  validate :cant_be_more_than_teams
  
  
  def cant_be_more_than_teams
    errors.add(:num_teams, " can't be bigger than the number of teams...") if num_teams.to_i < user_first_pick.to_i
  end
  
end
