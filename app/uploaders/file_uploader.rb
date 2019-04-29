class FileUploader < CommonUploader
  def extension_whitelist
    %w[pdf]
  end

  def cover
    manipulate! do |image|
      image.format('png', 0) do |c|
        c.fuzz        '3%'
        c.trim
        c.colorspace  'sRGB'
      end
      image
    end
  end

  version :preview do
    process :cover
    process convert: :png
    process resize_to_fit: [200,200]

    def full_filename (for_file = model.source.file)
      super.chomp(File.extname(super)) + '.png'
    end
  end
end
