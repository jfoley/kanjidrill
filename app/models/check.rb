class Check < ActiveRecord::Base
  attr_accessible :result, :kanji_id, :user_id

  belongs_to :kanji
  belongs_to :user
end
