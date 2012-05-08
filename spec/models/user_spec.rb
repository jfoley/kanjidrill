require 'spec_helper'

describe User do
  it "has a whitelist of accessible attributes" do
    user = Factory.build(:user)

    user.should allow_mass_assignment_of :email
    user.should allow_mass_assignment_of :password
    user.should allow_mass_assignment_of :password_confirmation
    user.should allow_mass_assignment_of :remember_me
  end

  it "has an attached avatar" do
    user = Factory.build(:user)

    user.should respond_to :avatar

    user.should have_db_column :avatar_file_name
    user.should have_db_column :avatar_content_type
    user.should have_db_column :avatar_file_size
    user.should have_db_column :avatar_updated_at
  end

  it "has columns required by devise" do
    user = Factory.build(:user)

    user.should have_db_column :email
    user.should have_db_column :encrypted_password
    user.should have_db_column :password_salt

    user.should have_db_column :reset_password_token
    user.should have_db_column :reset_password_sent_at

    user.should have_db_column :remember_created_at

    user.should have_db_column :sign_in_count
    user.should have_db_column :current_sign_in_at
    user.should have_db_column :last_sign_in_at
    user.should have_db_column :current_sign_in_ip
    user.should have_db_column :last_sign_in_ip
  end

  it { should have_many :checks }

  # these are taken care of by devise, but still test that its hooked up
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
end
