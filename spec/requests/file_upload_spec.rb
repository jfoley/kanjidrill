# coding: utf-8

require 'spec_helper'
require 'aws-sdk'
require Rails.root.join('lib', 's3_bucket_url')

include Warden::Test::Helpers
include S3

describe 'Avatar upload' do
  before(:all) do
    # webkit doesn't seem to handle file uploads, so we have to use selenium
    Capybara.javascript_driver = :selenium
  end

  it 'Uploads a file to S3', :js => true do
    user = Factory.create(:user)
    login_as user, scope: :user

    visit dashboard_path
    page.should have_content 'Choose Avatar'
    find('img.avatar').should be_present

    # click_button 'Choose Avatar'
    attach_file("file", Rails.root.join('spec', 'support', 'fat_cat.png'))

    # test that the file is actually on S3
    s3 = AWS::S3.new
    bucket = s3.buckets[ENV['AWS_S3_BUCKET']]
    uploaded_file = bucket.objects[s3_key_base + '/fat_cat.png']
    wait_until(10) { uploaded_file.exists? }

    uploaded_file.should exist

    # get delayed job to process it
    wait_until { Delayed::Job.count > 0 }
    Delayed::Job.first.invoke_job

    # the client is polling for the processed image
    wait_until(30) { find('img.avatar')[:src].match('fat_cat.png') }

    # make sure the temporary uploaded file is deleted
    uploaded_file.should_not exist
  end
end

