require "uglifier"

module Jekyll
  class UglifierConverter < Converter
    priority :low

    def matches(ext)
      ext =~ /^\.js$/i
    end

    def output_ext(ext)
      ".js"
    end

    def convert(content)
      if ENV["JEKYLL_ENV"] == "production"
        Uglifier.compile(content)
      else
        content
      end
    end
  end
end
