---
---
var params = new URLSearchParams(location.search);

{% raw %}
const template = `
  <div class="post" v-for="post in filteredPosts">
      <a class="post-title" v-bind:href="post.url">{{ post.title }}</a><br>
      <small>{{ post.date }}</small>
      <img class="img-small" alt="Cover image" v-bind:src="post.cover" v-if="post.cover != ''">
      <p v-html="post.description"></p>
      <small>Tags: {{ post.tags }}</small>
    </div>
`
{% endraw %}


// The results_wrapper div is pre-loaded with all search results by
// jekyll to avoid flashing the Vue templating as well as to 
// Allow Google search results to not look ridiculous.
// This replaces the HTML with the Vue Template once vue is loaded.
const postResults = document.querySelector(".results-wrapper");
postResults.innerHTML = template;

const app = new Vue({
  el: '#app',
  data: {
    search: params.has('q') ? params.get('q') : '',
    post_list: posts
  },
  computed: {
    filteredPosts() {
      return this.post_list.filter( post => {
        return `${post.tags} ${post.title}`.toLowerCase().includes(this.search.toLowerCase());
      });
    }
  }
})

document.querySelector('.search').addEventListener('focus', function () {
  window.scroll({
    top: this.offsetTop - 100,
    left: 0,
    behavior: 'smooth'
  });
});
