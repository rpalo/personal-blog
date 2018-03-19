module Jekyll
  Jekyll::Hooks.register :site, :pre_render do |site|
    site.tags.keys.each do |tag|
      unless File.exist?("tags/#{tag}.md")
        content = <<~HEREDOC
          ---
          layout: tagpage
          tag: #{tag}
          permalink: /tags/#{tag}
          ---
        HEREDOC
        File.open("tags/#{tag}.md", "w") do |f|
          f.write(content)
        end
      end
    end
  end
end
