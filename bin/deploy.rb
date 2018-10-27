#!/usr/bin/env ruby
# A deploy script for the blog

require "fileutils"
require "json"
require "httparty"
require "ostruct"
require "optparse"
require "uri"
require "yaml"

BUILD_DIR = "_site"
BUILD_REPO = "rpalo.github.io"

def main
  $stdout.sync = true

  options = get_cmdline_options!
  
  # Check for presence of build-repo in _site dir
  if !Dir.exist?(BUILD_DIR) || !dir_is_git_repo("_site", BUILD_REPO)
    puts "Warn: Build repo not present.  Cloning now."
    clear_and_clone_build_repo(options["noop"])
  end

  ensure_file("cloudinary.yml")
  ensure_file("secrets.yml")
  
  # Build Deployment version of the site
  section_message("[1/5] Building the Production Site")
  ENV["JEKYLL_ENV"] = "production"
  build_site(options["noop"])

  # Commit and push changes to source repo
  section_message("[2/5] Committing and Pushing Source Repo")
  git_add_commit_push(options["commit_message"], noop: options["noop"])

  # Commit and push newly deployed site
  section_message("[3/5] Committing and Pushing Deploy Repo")
  git_add_commit_push(options["commit_message"], dir: BUILD_DIR, noop: options["noop"])

  # Wait for Github to refresh
  section_message("[4/5] Waiting for Github to Refresh")
  countdown(10)

  # Purge Post Lists Cache
  section_message("[5/5] Purge Posts List Cache")
  clear_posts_cache(options["noop"])

  section_message("Complete!")
end

def get_cmdline_options!
  options = {
    "noop" => false
  }

  opt_parser = OptionParser.new do |opts|
    opts.banner = <<~HEREDOC
      Deploy: Deploy the Assert Not Magic blog.
      
      Usage: deploy.sh [options]
      HEREDOC

    opts.on("-n", "--noop", "Dry run through the script without doing anything.") do
      options["noop"] = true
    end

    opts.on("-h", "--help", "Prints this help") do
      puts opts
      exit
    end
  end

  opt_parser.parse!(ARGV)
  options["commit_message"] = ARGV.pop

  options
end

def clear_and_clone_build_repo(noop = false)
  if noop 
    FileUtils.rm_rf(BUILD_DIR, noop: true)
    puts "Cloning 'https://github.com/rpalo/#{BUILD_REPO} #{BUILD_DIR}'"
  else
    FileUtils.rm_rf(BUILD_DIR)
    `git clone https://github.com/rpalo/#{BUILD_REPO} #{BUILD_DIR}`
  end
end
 
def build_site(noop = false)
  if noop
    puts "bundle exec jekyll build"
  else
    puts `bundle exec jekyll build`
  end
end

def git_add_commit_push(message, dir: ".", noop: false)
  Dir.chdir(dir) do
    if noop
      puts "git add ., git commit -m #{message}, git push"
      return
    else
      `git add .`
      `git commit -m "#{message}"`
      `git push`
    end
  end
end

def countdown(n)
  n.downto(0) do |i|
    print(format("Waiting: %02d\r", i))
    sleep(1)
  end
end

def clear_posts_cache(noop = false)
  if noop
    response = OpenStruct.new(:code => 200, :body => "Dummy Request")
  else
    secrets = YAML.load(File.read("secrets.yml"))
    response = HTTParty.post(
      "https://api.cloudflare.com/client/v4/zones/13f84c3ce59abf8d0e7a6ef82a2d0385/purge_cache",
      :body => {
        "files" => ["https://assertnotmagic.com/js/posts_data.js"]
      }.to_json,
      :headers => {
        "Content-Type" => "application/json",
        "X-Auth-Email" => secrets["email"],
        "X-Auth-Key" => secrets["cloudflare_api_key"]
      }
    )
  end

  puts "#{response.code}: #{response.body}"
end

def dir_is_git_repo(dir, repo_name)
  Dir.chdir(dir) do
    git_remote_info = `git remote -v`
    git_remote_info =~ /#{repo_name}/
  end
end

def ensure_file(filename)
  if !File.exist?(filename)
    abort("Error: No #{filename} present.  Create one from the template.")
  end
end

def section_message(message)
  puts
  puts "--- #{message} ---"
  puts
end

main
