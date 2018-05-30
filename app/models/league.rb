class League < ApplicationRecord
  # Direct associations

  has_many   :drafts,
             :foreign_key => "draft_id",
             :dependent => :destroy

  belongs_to :user,
             :counter_cache => true

  # Indirect associations

  # Validations

end
