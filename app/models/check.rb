class Check < ActiveRecord::Base
  attr_accessible :result, :kanji_id, :user_id

  belongs_to :kanji
  belongs_to :user

  validates :result,
    :presence => true,
    :inclusion => { :in => [:again, :hard, :normal, :easy] }
  validates :kanji_id, :presence => true
  validates :user_id, :presence => true
end
