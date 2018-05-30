class Draft < ApplicationRecord
  # Direct associations

  belongs_to :players,
             :required => false,
             :class_name => "Player",
             :counter_cache => true

  # Indirect associations

  # Validations

end
