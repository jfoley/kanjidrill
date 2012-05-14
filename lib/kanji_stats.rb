class KanjiStats
  def initialize(user, kanji)
    @user = user
    @kanji = kanji
  end

  def stats
    {
      :last_seen    => last_check_at,
      :again_count  => again_count,
      :hard_count   => hard_count,
      :normal_count => normal_count,
      :easy_count   => easy_count
    }
  end

  def as_json(options = nil)
    stats
  end

  private
  def last_check_at
    checks = base_query.order('created_at DESC').limit(2).all

    if checks.length > 1
      return checks.last.created_at
    else
      return nil
    end
  end

  def again_count
    base_query.where(:result => :again).count
  end

  def hard_count
    base_query.where(:result => :hard).count
  end

  def normal_count
    base_query.where(:result => :normal).count
  end

  def easy_count
    base_query.where(:result => :easy).count
  end

  def base_query
    @user.checks.where(:kanji_id => @kanji.id)
  end
end
