class PictureUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  process resize_to_limit: [400, 400]
  storage :file

  if Rails.env.production?
    storage :aws
  else
    storage :file
  end

  def store_dir
    if Rails.env.production?
      "training/gatchan/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    else
      "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    end
  end

  def extension_whitelist
    %w(jpg jpeg gif png)
  end

end
