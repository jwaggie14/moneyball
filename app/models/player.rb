class Player < ApplicationRecord
  # Direct associations

  has_many   :drafts,
             :foreign_key => "players_id"

  # Indirect associations

  # Validations

end
