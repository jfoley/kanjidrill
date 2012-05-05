class User < ActiveRecord::Base
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable
         #:encryptable

  attr_accessible :email,
                  :password,
                  :password_confirmation,
                  :remember_me

  has_many :checks

  def stats(kanji)
    check_relation = self.checks.where(:kanji_id => kanji.id)

    {
      :last_seen => check_relation.order('created_at DESC').first.created_at.getutc.iso8601,
      :no_count => check_relation.where(result: 'no').count,
      :maybe_count => check_relation.where(result: 'maybe').count,
      :yes_count => check_relation.where(result: 'yes').count
    }
  end
end
