class Player < ApplicationRecord
  # Direct associations

  has_many   :drafts,
             :foreign_key => "players_id"

  # Indirect associations

  has_many   :leagues,
             :through => :drafts,
             :source => :league

  # Validations

end
