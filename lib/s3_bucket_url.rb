module S3
  def s3_bucket_url
    "https://#{ENV['AWS_S3_BUCKET']}.s3.amazonaws.com/"
  end

  def s3_key_base
    "#{Rails.env}/uploads"
  end

  def s3_url(filename)
    URI.escape(s3_bucket_url + s3_key_base + '/' + filename)
  end
end
