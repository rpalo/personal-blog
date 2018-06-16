---
---
const posts = [
    {% for post in site.posts %}
    {
        title: "{{ post.title }}",
        url: "{{ site.baseurl}}{{ post.url }}",
        cover: "{{ 'https://res.cloudinary.com/duninnjce/image/upload/w_300,q_auto,f_auto/' | append: post.cover_image }}",
        tags: "{{ post.tags | join: ', ' }}",
        date: "{{ post.date | date: '%B %d, %Y' }}",
        description: "{{ post.description | strip_html | strip_newlines | escape }}"
    } {% unless forloop.last %},{% endunless %}
    {% endfor %}
];