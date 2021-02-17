source "https://rubygems.org"
ruby RUBY_VERSION

gem "jekyll"
# If you want to use GitHub Pages, remove the "gem "jekyll"" above and
# uncomment the line below. To upgrade, run `bundle update github-pages`.
gem 'jekyll-autoprefixer' # Plugin for autoprefixing CSS so you don't have to mess with that
gem "babel-transpiler"    # Use modern JavaScript (works kind of)
gem "uglifier"            # Uglifies/compresses the JavaScript
gem "tzinfo"              # Only required because I develop on Windows occasionally
gem "tzinfo-data"         # Same same
gem "cloudinary"          # Cloudinary for uploading files
gem 'liquid'
gem 'httparty'            # Only used for HTTP calls.  Not even really currently used.

group :jekyll_plugins do
  gem 'jekyll-cloudinary' # Jekyll cloudinary integration for liquid tag
  gem 'jekyll-sitemap'    # Autogenerate a sitemap because sitemaps are good and I am lazy
  gem 'jekyll-asciidoc'   # Trying out AsciiDoc
end
