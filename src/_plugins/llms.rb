require "pathname"



module Jekyll

  class GeneratedMarkdownPage < Page
    def initialize(site, base, page, basename, url, content)
      @site = site
      @base = base

      self.process(basename)
      self.data = page.data.clone
      self.data['layout'] = nil

      self.data['permalink'] = (Pathname(url).parent / "#{basename}.md").to_s

      _, frontmatter, body = content.split("---", 3)
      frontmatter = frontmatter
        .strip
        .split("\n")
        .select do |line|
          key, val = line.split(": ", 2)
          line.strip and (not key or %w[title description tags].include?(key))
        end.join("\n")

      self.content = <<~MARKDOWN
        ---
        #{frontmatter}
        ---

        # #{page.data['title']}
        
        #{body.strip}"
      MARKDOWN

    end
  end


  class MarkdownPageExporter < Generator
    safe true
    priority :low

    def generate(site)
      # We collect pages to add first so we don't mutate the array during iteration
      new_md_pages = []

      site.pages.each do |page|
        # Skip asset files and existing markdown/text source files
        next unless page.path.end_with?(".md")
        next if page.url.include?("tags/")

        if not page.data['permalink']
          puts "No permalink available for #{page.path}"
          next
        end
        
        # Generate the file cleanly in-memory
        new_md_pages << GeneratedMarkdownPage.new(
          site, 
          site.source, 
          page,
          page.basename,
          page.data['permalink'],
          File.read(File.join(site.source, page.path), encoding: 'utf-8')
        )
      end

      site.posts.docs.each do |post|
        next unless post.path.end_with?(".md")

        new_md_pages << GeneratedMarkdownPage.new(
          site,
          site.source,
          post,
          post.data['slug'].delete_suffix(".md"),
          post.url,
          File.read(post.path, encoding: 'utf-8')
        )
      end

      # Safely inject the new dynamic pages into Jekyll's active site array
      site.pages.concat(new_md_pages)
    end
  end
end
