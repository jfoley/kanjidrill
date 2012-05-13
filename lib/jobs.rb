require 'open-uri'

module Jobs
  class ProcessAvatarJob < Struct.new(:user, :remote_url)
    def perform
      remote_file = open(remote_url)
      delete_s3_file(remote_url)

      # monkey patch the file object to have an original_filename method
      def remote_file.original_filename; base_uri.path.split('/').last; end

      user.avatar = remote_file
      user.save!
    end

    private
    def delete_s3_file(remote_url)
      s3_key = URI::parse(remote_url).path[1..-1] # chop the leading /
      s3 = AWS::S3.new
      bucket = s3.buckets[ENV['AWS_S3_BUCKET']]
      object = bucket.objects[s3_key]

      object.delete
    end
  end
end
