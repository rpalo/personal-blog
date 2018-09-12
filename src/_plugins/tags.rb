require "set"

module Jekyll
  # Syncs the tagpages with the tags in all of my posts
  Jekyll::Hooks.register :site, :post_read do |site|
    tags = Set.new(site.tags.keys)
    tagpage_filenames = Dir.entries("./src/tags/")
    .grep(/\.md/)
    .map do |filename|
      filename.chomp(".md")
    end
    tagpages = Set.new(tagpage_filenames)
    tags_without_pages = tags - tagpages
    pages_without_tags = tagpages - tags

    # Create a tagpage for any tag without a page
    tags_without_pages.each do |tag|
      puts "Creating new tagpage for: #{tag}"
      content = <<~HEREDOC
        ---
        layout: tagpage
        tag: #{tag}
        permalink: /tags/#{tag}/
        ---
      HEREDOC
      File.open("src/tags/#{tag}.md", "w") do |f|
        f.write(content)
      end
    end

    # Delete the tagpage for any page that doesn't have any tags
    pages_without_tags.each do |page|
      puts "Removing tagpage for nonexistent tag: #{page}.  Ignore any Ruby errors reported."
      File.delete("src/tags/#{page}.md")
    end
  end
end
