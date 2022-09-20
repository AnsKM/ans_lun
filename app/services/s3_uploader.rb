class S3Uploader

  def initialize()
    @aws_access_key_id = APP_CONFIG.aws_access_key_id
    @aws_secret_access_key = APP_CONFIG.aws_secret_access_key
    @bucket = APP_CONFIG.s3_upload_bucket_name
    @acl = "public-read"
    @expiration = 10.hours.from_now
    @s3_region = APP_CONFIG.s3_region
    @current_dt = DateTime.now
    @policy_date = @current_dt.utc.strftime("%Y%m%d")
    @x_amz_date = @current_dt.utc.strftime('%Y%m%dT%H%M%SZ')
    @x_amz_algorithm = "AWS4-HMAC-SHA256"
    @x_amz_credential = "#{@aws_access_key_id}/#{@policy_date}/#{@s3_region}/s3/aws4_request"
  end

  def fields
    {
      :key => key,
      :acl => @acl,
      :success_action_status => 200,
      'X-Amz-Credential': @x_amz_credential,
      'X-Amz-Algorithm': @x_amz_algorithm,
      'X-Amz-Date': @x_amz_date,
      'X-Amz-Signature': signature,
      'Policy': policy
    }
  end

  def url
    "https://#{@bucket}.s3.amazonaws.com/"
  end

  private

  def url_friendly_time
    Time.now.utc.strftime("%Y%m%dT%H%MZ")
  end

  def year
    Time.now.year
  end

  def month
    Time.now.month
  end

  def key
    "uploads/listing-images/#{year}/#{month}/#{url_friendly_time}-#{SecureRandom.hex}/${index}/${filename}"
  end

  def policy
    Base64.encode64(policy_data.to_json).gsub("\n", "")
  end

  def policy_data
    {
      expiration: @expiration.utc.iso8601,
      conditions: [
        ["starts-with", "$key", "uploads/listing-images/"],
        ["starts-with", "$Content-Type", "image/"],
        ["starts-with", "$success_action_status", "200"],
        ["content-length-range", 0, APP_CONFIG.max_image_filesize],
        {"x-amz-algorithm" => @x_amz_algorithm },
        {"x-amz-credential" => @x_amz_credential },
        {"x-amz-date" => @x_amz_date},
        {bucket: @bucket},
        {acl: @acl}
      ]
    }
  end

  def get_signature_key( key, date_stamp, region_name, service_name )
    k_date = OpenSSL::HMAC.digest('sha256', "AWS4" + key, date_stamp)
    k_region = OpenSSL::HMAC.digest('sha256', k_date, region_name)
    k_service = OpenSSL::HMAC.digest('sha256', k_region, service_name)
    k_signing = OpenSSL::HMAC.digest('sha256', k_service, "aws4_request")
    k_signing
  end

  def signature
    signature_key = get_signature_key( @aws_secret_access_key, @policy_date , @s3_region, "s3")
    OpenSSL::HMAC.hexdigest('sha256', signature_key, policy )
  end
end