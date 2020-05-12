---
---
const posts = [
    {% for post in site.posts %}
    {
        title: "{{ post.title }}",
        url: "{{ site.baseurl}}{{ post.url }}",
        cover: "{% if post.cover_image %}{{ 'https://res.cloudinary.com/duninnjce/image/upload/c_scale,w_300,q_auto,f_auto/' | append: post.cover_image }}{% endif %}",
        tags: "{{ post.tags | join: ', ' }}",
        category: "{{ post.category }}",
        date: "{{ post.date | date: '%B %d, %Y' }}",
        description: "{{ post.description | strip_html | strip_newlines | escape }}"
    } {% unless forloop.last %},{% endunless %}
    {% endfor %}
];