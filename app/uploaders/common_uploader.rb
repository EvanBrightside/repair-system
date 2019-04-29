class CommonUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file
end
