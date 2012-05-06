class AvatarController < ApplicationController
  def s3_policy
    render :json => {
      :policy => s3_upload_policy_document,
      :signature => s3_upload_signature,
      :key => 'uploads/${filename}'
    }
  end

  def fetch_avatar
    current_user.avatar.destroy
    current_user.avatar.clear
    current_user.save!

    job = Jobs::ProcessAvatarJob.new(current_user, params[:remote_url])
    Delayed::Job.enqueue job

    head :ok
  end

  def poll
    if current_user.avatar.present?
      render :json => {
        thumb: current_user.avatar.url(:thumb),
        profile: current_user.avatar.url(:profile)
      }
    else
      render :json => { noop: true }
    end
  end

  private
  def s3_upload_signature
    signature = Base64.encode64(
      OpenSSL::HMAC.digest(OpenSSL::Digest::Digest.new('sha1'),
      ENV['AWS_SECRET_KEY'],
      s3_upload_policy_document)
    ).gsub("\n","")
  end

  def s3_upload_policy_document
    ret = {"expiration" => 5.minutes.from_now.utc.xmlschema,
      "conditions" =>  [
        {"bucket" =>  ENV['AWS_S3_BUCKET']},
        ["starts-with", "$key", 'uploads/'],
        {"acl" => "public-read"},
        {"success_action_status" => "200"},
        ["content-length-range", 0, 5242880] # 5MB
      ]
    }

    Base64.encode64(ret.to_json).gsub(/\n/,'')
  end
end
