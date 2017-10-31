
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
})