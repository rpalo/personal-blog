require 'cloudinary'

ENV['CLOUDINARY_CONFIG_DIR'] = '.'
ENV['CLOUDINARY_ENV'] = 'jekyll'

image_name = ARGV[0]
extension = '.' + image_name.split('.')[-1]
image_path = "src/img/#{image_name}"
public_id = File.basename(image_name, extension)

abort "#{image_path} does not exist." unless File.exists?(image_path)

puts "Uploading #{image_path} with public_id #{public_id}"
begin
  Cloudinary::Uploader.upload(image_path, :public_id => public_id)
rescue CloudinaryException => e
  abort "Cloudinary Error: #{e.message}"
end

puts "Sucess!"