class PhotoUploader < CommonUploader
  version :preview do
    process resize_to_fill: [200, 200]
  end

  def extension_whitelist
    %w(jpg jpeg png)
  end
end
