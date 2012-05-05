class Check < ActiveRecord::Base
  attr_accessible :result, :kanji_id

  belongs_to :kanji
end
