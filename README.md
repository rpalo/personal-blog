# Assert Not Magic

*Assert Not Magic* is my personal blog.  It's also my testing/practice ground for HTML, CSS, JavaScript, Sass, Ruby, Shell Scripts, JAM Stack, API interaction, Vue, and more.  I write on it because I love writing, I need to write things down to remember them later, and hopefully, the things I write down help other people.

## Overview

### Root Directory

This is a Jekyll-powered blog, and I've stuck to most of the Jekyll conventions.  The main difference is that I've shifted the site source directory into `src` to clean up the root directory, and I've added the `bin` directory for development scripts and the `lib` directory for more carefully laid-out scripts.  Since the scripts in `lib` need to be called in certain ways, there should probably be a script in the `bin` directory that makes it easy to call the `lib` scripts.

### Source Root

My source root contains a smattering of files that make browsers and search engines do cool things with my site.  Most of them aren't that important.  The main root pages I have are:

 - index.html: My homepage/landing page
 - posts.html: The main listing page for my posts
 - uses.html: A list of tools and apps I love to use
 - about.md: An "about the author" contact type page

On top of that, we also have the following Jekyll-based directories:

 - _includes: Little snippets to get included in other files
 - _layouts: Main layouts that can be selected on a page-by-page basis
 - _plugins: Custom plugins I've written to help with the site build
 - _posts: Where I keep my posts
 - _sass: The support/load directory for my sass files.  Not directly published.
 - css: These Sass files get build and published on the live site
 - js: Javascript code.  Primarily, this is to make my posts page shwoopy.
 - tags: I've hand-rolled my own tags solution for the tag pages, so Jekyll automatically builds pages for each of my tags so all the tagged posts get listed for that tagpage

## Development Setup (for Contributing or Forking)

In order to get things up and running, you need to have the Ruby version listed in the `.ruby-version` file and Bundler 2+.

1. Pick and choose which gems you want to make use of in the Gemfile.  I've tried to comment them up so you can make intelligent decisions about which ones you need.
2. Copy the example cloudinary configuration file (if using cloudinary) to `cloudinary.yml`.

    cp cloudinary.example.yml cloudinary.yml

3. Replace most of the `_config.yml` values with your own.  Check out Jekyll's config docs for a less pared down version since mine is basically only what I need.
4. I'd appreciate it if you blew away the `_posts` directory.  I spend a lot of time on my posts, and copying them and displaying them as your own is lame.
5. Start her up and see how she runs.  I've simplified (?  Maybe?  Like a few keystrokes?) the serving process so you can run

    bin/serve

## Contributing

I'm really open to contributors and guest posts.  I've never had that before, but there's a first time for everything.  Open up an issue or shoot me an e-mail to discuss how we can work together.

## Code of Conduct

See my [Code of Conduct](CODE_OF_CONDUCT.md) for contributing to this project.
