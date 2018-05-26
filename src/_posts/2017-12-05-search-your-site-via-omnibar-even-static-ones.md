---
layout: page
title: Search Your Site via the Omnibar (Even Static Sites)
description: A quick guide for how to add Chrome Omnibar search functionality to your websites.
tags: browser html javascript tutorial
cover_image: omnibar.png
---

A little while ago, [Tiffany White](https://dev.to/twhite) posted an update on [Dev.to](https://dev.to), documenting a new feature: Chrome Omnibar search.  

![Searching with the omnibar](/img/omnibar-in-action.gif)

It's one of those features that I take for granted on so many of the popular sites that I use, not considering the fact that I could actually have that feature on my own site!  So I looked into how to implement it, and I wanted to share what I found with everybody else.  Part of the point of this post is that I cobbled my suggestion together from a bunch of different search results I found, so if I missed something important, let me know and I'll add it to the guide (and update how I did it on my blog).  

## Part 1: OpenSearch

The first (and almost only) thing you'll need is to add a `/opensearch.xml` file (in the root of your website) with the contents below.  I'm using my blog in the links below.  You'll probably want to change things to match your site, unless you really like me and want to forward your search traffic to me.

```xml
<OpenSearchDescription xmlns="http://a9.com/-/spec/opensearch/1.1/" xmlns:moz="http://mozilla.org/2006/browser/search/">
	<ShortName>Assert_Not Magic</ShortName>
  	<Description>Search blog posts on assert_not magic</Description>
  	<InputEncoding>UTF-8</InputEncoding>
  	<Image width="16" height="16" type="image/png">https://assertnotmagic.com/favicon-16x16.png</Image>
  	<Url type="text/html" method="get" template="https://assertnotmagic.com/posts/?q={searchTerms}" />
  	<Url type="application/opensearchdescription+xml" rel="self" template="https://assertnotmagic.com/opensearch.xml" />
  	<SearchForm>https://assertnotmagic.com/posts/</SearchForm>
  	<moz:SearchForm>https://assertnotmagic.com/posts/</moz:SearchForm>
</OpenSearchDescription>
```

A quick description of each item:

**ShortName**: A short name for you (and the browser) to refer to your search engine by (< 16 characters).

**Description**: A longer description (< 1024 characters).

**InputEncoding**: The encoding of characters to expect.

**Image**: The absolute path to (or Base64 data representation of) an icon of your choosing to show up next to search bars in some clients (see the image below).  Make sure the `type` matches the filetype of your image (whether it's `.png, .jpg, or .ico`).

**Url**: This is the URL that gets pinged when the user completes their search.  Note that it uses a "magical" {searchTerms}.  It will fill in the URL with whatever the user types.

**Url (The second one)**: You can include this and some browsers will automatically update themselves ~~if~~ WHEN you make changes to your `opensearch.xml`.  More on that in a second.

**SearchForm/moz:SearchForm**: Tags that hold a link to your search page.  I believe this is so that if your user gets frustrated with the Omnibar, they can say "BAH.  Just take me to their search page and I'll do it there."

The [Firefox OpenSearch documentation](https://developer.mozilla.org/en-US/docs/Web/OpenSearch) has some solid guidance to these terms, what is involved, and what is required, if you're not satisfied with my explanation.  They also have help for if you want to use the Omni-bar to ping a JSON endpoint.

### Possible Gotcha: Updating During Development

While you're getting setup, it's possible that you'll make a typo or a mistake somewhere.  And then you'll wonder how you clear the @!#$ing cache so your browser reloads the new configuration.  For Chrome, you can right-click the Omnibar and select "Edit Search Engines".  Find your bar in that menu and delete it to allow your browser to pull in your most recent update.  In theory, the auto-update URL above should save you from this, but this can be your backup nuclear option.

![How to clear the OpenSearch cache](/img/omnibar-cache.png)

## Part 2: Link Tag

Next, all you need to do is throw a `link` tag into your `head` section.  I think it's enough to just have it on your homepage.  Someone correct me if that's not true.

```html
<!-- index.html -->
<!DOCTYPE HTML>
<html lang="en">
  <head>
    <!-- ... All the rest of your head tags -->
    <link rel="search"
          type="application/opensearchdescription+xml"
          title="Search assert_not magic"
          href="/opensearch.xml">
  </head>
  <!-- ... the rest of your site -->
</html>
```

And you should be good to go!  If you've got your own back-end, you can process the `q={searchTerms}` from the XML document above in the `GET` request to your Search Results page.  But what if you don't *have* a back end?

## Bonus Part: Static Sites

No back end?  No worries!  I'll show you how to make it work with your dynamic JavaScript search form.  In [a previous post](https://assertnotmagic.com/2017/11/11/static-site-search-with-vue/), I walked through how I added search functionality to my static-ly generated blog.  I'm going to use the code from the end of that post as a starting point.  For those that are too lazy to click the link:

```javascript
const app = new Vue({
  el: '#app',
  data: {
    search: '',
    post_list: posts
  },
  computed: {
    filteredPosts() {
      return this.post_list.filter( post => {
        return `${post.tags} ${post.title}`.toLowerCase().includes(this.search.toLowerCase());
      });
    }
  }
});
```

The trick that we're going to pull is that as we're creating the Vue-powered search component, we're going to check our URL for parameters.  Place this before the above code.

```javascript
const params = new URLSearchParams(location.search);
```

`URLSearchParams` are a handy dandy way to parse parameters (everything after the `?`) in a url.  While browser support isn't quite 100%, I'm going to assume that a) you have transpilation figured out, b) you know [how to @ me](https://twitter.com/paytastic), and I'll help you out.

Now that we have our parameters (if they exist), let's use them to have our search component pre-load the searched items.

```javascript
const params = new URLSearchParams(location.search);

const app = new Vue({
  el: '#app',
  data: {
    search: params.has('q') ? params.get('q') : '',  // <- This is the key part
    post_list: posts
  },
  computed: {
    filteredPosts() {
      return this.post_list.filter( post => {
        return `${post.tags} ${post.title}`.toLowerCase().includes(this.search.toLowerCase());
      });
    }
  }
});
```

If our URL has a `q` parameter (which it does if it's coming from the Omni-bar search), we load that into the search box, which causes our search results to update.  Otherwise, we start with a blank search box and carry on as usual.

![Here's how it works on my site](/img/omnibar-in-action.gif)

And that's it!  Like I said, if you know of any best practices for OpenSearch that I'm missing or ways that I can use it better/cooler, let me know and I'll try to update the post.

**Extra References:**

- [Enhance your site with opensearch - Wynn Netherland](https://wynnnetherland.com/journal/enhance-your-site-search-with-opensearch/)
- [Mozilla OpenSearch Docs](https://developer.mozilla.org/en-US/docs/Web/OpenSearch)
- [On the Importance of OpenSearch - Scott Hanselman](https://www.hanselman.com/blog/OnTheImportanceOfOpenSearch.aspx)