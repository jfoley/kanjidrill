class User < ActiveRecord::Base
  attr_accessible :email,
                  :password,
                  :password_confirmation,
                  :remember_me

  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable,
         :encryptable,
         :encryptor => :authlogic_sha512

  has_many :checks
  has_attached_file :avatar, :styles => { :profile => "100x100>", :thumb => "30x30>" }
end
