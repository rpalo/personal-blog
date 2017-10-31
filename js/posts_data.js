---
---
const posts = [
    {% for post in site.posts %}
    {
        title: "{{ post.title | escape }}",
        url: "{{ site.baseurl}}{{ post.url }}",
        cover: "/img/{{ post.cover_image }}",
        tags: "{{ post.tags | join: ', ' }}",
        date: "{{ post.date | date: '%B %d, %Y' }}",
        description: "{{ post.description | strip_html | strip_newlines | escape }}"
    } {% unless forloop.last %},{% endunless %}
    {% endfor %}
];