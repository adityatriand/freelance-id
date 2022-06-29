class PortoAttachmentUploader < CarrierWave::Uploader::Base
  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  if Rails.env.test? || Rails.env.cucumber?
    CarrierWave.configure do |config|
      config.storage = :file
      config.enable_processing = true
    end

    CarrierWave::Uploader::Base.descendants.each do |klass|
    next if klass.anonymous?
      klass.class_eval do
        def cache_dir
          "#{Rails.root}/spec/support/uploads/tmp"
        end
  
        def store_dir
          "#{Rails.root}/spec/support/uploads/portofolio"
        end

      end
    end
  else
    def store_dir
      # "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
      "uploads/portofolio"
    end
  end

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url(*args)
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process scale: [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process resize_to_fit: [50, 50]
  # end

  # Add an allowlist of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_allowlist
    %w(jpg jpeg png pdf doc docx xls xlsx ppt pptx)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

  def filename
    "portofolio_#{secure_token(16)}.#{file.extension}" if original_filename.present?
  end

  protected
  def secure_token(length=32)
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.hex(length/2))
  end
end
