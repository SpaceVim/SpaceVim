     return unless original_filename

     if model && model.read_attribute(mounted_as).present?
       model.read_attribute(mounted_as)
     else
       "#{SecureRandom.hex(5)}.#{file.extension}"
     end
   end

   def store_dir
     "u/#{model.user_id}/#{model.id}"
   end

   def extension_whitelist
     %w[jpg jpeg png]
   end

   version :thumb do
     process resize_to_fit: [150, 150]
   end
 end
