class Kanji < ActiveRecord::Base
  attr_accessible :glyph, :meaning, :grade_id

  belongs_to :grade
  has_many :checks
end
