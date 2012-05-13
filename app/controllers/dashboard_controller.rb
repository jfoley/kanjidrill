require Rails.root.join('lib', 's3_bucket_url')

class DashboardController < ApplicationController
  include S3
  helper_method :s3_bucket_url

  def show
  end
end
