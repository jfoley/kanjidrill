module DashboardHelper
  def s3_bucket_url
    "https://#{ENV['AWS_S3_BUCKET']}.s3.amazonaws.com"
  end
end
