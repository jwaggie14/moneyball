class Draft < ApplicationRecord
  # Direct associations

  belongs_to :league,
             :foreign_key => "draft_id",
             :counter_cache => true

  belongs_to :players,
             :required => false,
             :class_name => "Player",
             :counter_cache => true

  # Indirect associations

  # Validations
  validates :draft_id, uniqueness: {scope: :pick_num}
end
