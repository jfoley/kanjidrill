class Kanji < ActiveRecord::Base
  attr_accessible :glyph, :meaning, :grade_id

  belongs_to :grade
  has_many :checks

  def stats
    {
      :last_seen => checks.order('created_at DESC').first.created_at.getutc.iso8601,
      :no_count => checks.where(result: 'no').count,
      :maybe_count => checks.where(result: 'maybe').count,
      :yes_count => checks.where(result: 'yes').count
    }
  end
end
