Paperclip::Attachment.default_options.merge!(
  :storage     => :s3,
  :s3_protocol => 'https',
  :s3_credentials => {
    :access_key_id     => ENV['AWS_ACCESS_KEY'],
    :secret_access_key => ENV['AWS_SECRET_KEY'],
    :bucket            => ENV['AWS_S3_BUCKET']
  },

  :path => "/:attachment/:id/:style/:basename.:extension",
  :default_url => "/:attachment/:style/missing.png",
)

