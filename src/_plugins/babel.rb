require "babel/transpiler"

module Jekyll
  class BabelConverter < Converter
    priority :high

    def matches(ext)
      ext =~ /^\.js$/i
    end

    def output_ext(ext)
      ".js"
    end

    def convert(content)
      if ENV["JEKYLL_ENV"] == "production"
        result = Babel::Transpiler.transform(content)
        result["code"]
      else
        content
      end
    end
  end
end
