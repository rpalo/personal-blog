require 'cloudinary'
require 'yaml'

Jekyll::Hooks.register :site, :pre_render do |site|
  auth = YAML.load(File.read('cloudinary.yml'), symbolize_names: true)
  resources = Cloudinary::Api.resources(auth)
  uploads = resources['resources'].map { |res| res['public_id'] }
  locals = site.static_files.select { |file| file.path =~ /img\/uploads\/.*\.(png|jpg|svg)/ }
  locals.each do |file|
    public_id = Jekyll::Utils.slugify(file.name)
    next if uploads.include?(public_id)
    options = auth.merge({
      public_id: public_id
    })
    Cloudinary::Uploader.upload(file.path, options)
    puts "New image found in uploads.  Uploading #{file.name} with public_id #{public_id}."
  end
end