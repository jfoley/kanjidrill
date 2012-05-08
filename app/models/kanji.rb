class Kanji < ActiveRecord::Base
  attr_accessible :glyph, :meaning, :grade_id

  belongs_to :grade
  has_many :checks

  validates :glyph,    :presence => true
  validates :meaning,  :presence => true
  validates :grade_id, :presence => true
end
