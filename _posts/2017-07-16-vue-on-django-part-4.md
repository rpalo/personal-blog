---
title: Vue on Django, Part 4
layout: page
description: Vue tutorial, part 4, where we wrap it all up
cover_image: django-vue.png
tags: vue django es6 tutorial
---

This is Part 4 of my tutorial for making a Vue app powered by a Django REST backend.  Finally!  We've done it.  You've done it.  But most importantly, I've done it.  😊  In the first part, we set up just the Vue side.  In Part 2, we set up the data model and got it so we could create and clear our Todos in the browser.  In Part 3, we set up the Django backend.  Part 4 will consist of giving our front end a way to talk to our backend, so that our todos can be persisted for all time.  This section will make some API calls, so it would be useful to you to have some kind of knowledge of HTTP requests and JavaScript promises.  If you're not familiar with these, you should at least be comfortable shrugging, following my lead, and Googling later.

## 0. Setting Up

We should only need one other thing installed for this part: Vue Resource, which helps us to make HTTP requests.

```bash
$ npm install -s vue-resource
```

That's it!  Let's get into the changes, shall we?

## 1. The Client-Side API Utility

Add a file called `api.js` to your `src/store` folder.  Here we go:

```javascript
// src/store/api.js

import Vue from 'vue'
import VueResource from 'vue-resource'

Vue.use(VueResource)

export default {
  get (url, request) {
    return Vue.http.get(url, request)
      .then((response) => Promise.resolve(response))
      .catch((error) => Promise.reject(error))
  },
  post (url, request) {
    return Vue.http.post(url, request)
      .then((response) => Promise.resolve(response))
      .catch((error) => Promise.reject(error))
  },
  patch (url, request) {
    return Vue.http.patch(url, request)
      .then((response) => Promise.resolve(response))
      .catch((error) => Promise.reject(error))
  },
  delete (url, request) {
    return Vue.http.delete(url, request)
      .then((response) => Promise.resolve(response))
      .catch((error) => Promise.reject(error))
  }
}
```

This file just exports an object with the HTTP methods we'll be using.  This way, you can call it via `api.post(stuff)`.  You'll see an example of this.  Keep in mind, that this section uses a lot of what I think is JavaScript promises, and I'm a little foggy on the inner workings of these so far.  It's on the list to read more in-depth about.

We're also going to update our `store.js` file to use these new methods in our actions.  Remember, actions are allowed to be asynchronus, but mutations must be synchronus.  This is why we do our API calls from within the actions, and it's a big part of why actions exist at all!

```javascript
// src/store/store.js

import Vue from 'vue'
import Vuex from 'vuex'
import api from './api.js'

Vue.use(Vuex)
const apiRoot = 'http://localhost:8000'  // This will change if you deploy later

const store = new Vuex.Store({
  state: {
    todos: []
  },
  mutations: {
    // Keep in mind that response is an HTTP response
    // returned by the Promise.
    // The mutations are in charge of updating the client state.
    'GET_TODOS': function (state, response) {
      state.todos = response.body
    },
    'ADD_TODO': function (state, response) {
      state.todos.push(response.body)
    },
    'CLEAR_TODOS': function (state) {
      const todos = state.todos
      todos.splice(0, todos.length)
    },
    // Note that we added one more for logging out errors.
    'API_FAIL': function (state, error) {
      console.error(error)
    }
  },
  actions: {
    // We added a getTodos action for the initial load from the server
    // These URLs come straight from the Django URL router we did in Part 3
    getTodos (store) {
      return api.get(apiRoot + '/todos/')
        .then((response) => store.commit('GET_TODOS', response))
        .catch((error) => store.commit('API_FAIL', error))
    },
    addTodo (store, todo) {
      return api.post(apiRoot + '/todos/', todo)
        .then((response) => store.commit('ADD_TODO', response))
        .catch((error) => store.commit('API_FAIL', error))
    },
    clearTodos (store) {
      return api.delete(apiRoot + '/todos/clear_todos/')
        .then((response) => store.commit('CLEAR_TODOS'))
        .catch((error) => store.commit('API_FAIL', error))
    }
  }
})

export default store
```

There is a lot of change in this file, but this is really the meat of it.  Everything else from here on out is really just book-keeping.  Keep in mind that because of the way we set everything up, we are able to hook our app up to a back-end database and we aren't even going to touch the Components at all!  That is the neatest part I think.

We're also going to add one line to our `main.js` file, right at the bottom.  When our app loads up, the last thing we want it to do before the client sees it is load up the todos array with the saved todos.

```javascript
// src/main.js

import Vue from 'vue'
import App from './App'

import store from './store/store.js'

/* eslint-disable no-new */
const v = new Vue({
  el: 'body',
  store: store,
  components: { App }
})

// This should be the only new line ***
v.$store.dispatch('getTodos')

```

There's just one more thing that we should do to make our lives easier.  Open up the file `format_index_html.py`.  There's a few typos here from the vue project template that will make our life hard.  Here's the fixed version.  It's pretty much the same with some quotation marks added.

```python
{% raw %}
import sys
import fileinput

file = 'templates/index.html'

with open(file, "r+") as f:
    s = f.read()
    f.seek(0)
    f.write("{% load staticfiles %}\n" + s)

for i, line in enumerate(fileinput.input(file, inplace=1)):
    sys.stdout.write(line.replace('href=//', "href=\"{% static '"))
for i, line in enumerate(fileinput.input(file, inplace=1)):
    sys.stdout.write(line.replace('css', "css' %}"))
for i, line in enumerate(fileinput.input(file, inplace=1)):
    sys.stdout.write(line.replace('src=//', "src=\"{% static '"))
for i, line in enumerate(fileinput.input(file, inplace=1)):
    sys.stdout.write(line.replace('js', "js' %}\""))
{% endraw %}
```

Again, this code came with the vue template, and it's pretty ok (maybe not my favorite).  But it's already written for us, so we're going with it.

## 2. Get Ready

That should just about do it.  Here's how we kick the whole thing off.

1. Make sure your virtual environment is active.

```bash
$ source .venv/bin/activate
# Windows: .venv\Scripts\activate
```

2. Run `./deploy.sh`.  If it complains about permissions, either `chmod` the permissions or just run `bash deploy.sh`.  On windows, you should be able to run all of the steps in the deploy script manually.  The only one you should change is running `python manage.py runserver 8000` instead of doing it in two steps.

3. Watch all of the output closely.  If there are any errors, you'll see them in this deluge of output.

4. Head over to localhost:8000 and enjoy!

## 2.5 Debugging

If it doesn't work, don't panic.  Check your browser console.  Errors there?  Errors of a 500 nature are most likely server side.  You're going to want to work on your django-rest app.  If the errors are on your javascript side, kill any running dev servers and run `npm run dev` to run the vue server standalone.  This won't have access to any server functions, but it will be easier to find the real error message.

## 3. Wrap Up

This has been a long one, and hopefully I didn't miss anything.  Since I spaced the posts out (which I regret), I had to play some games with reminding myself what changed from Part to Part.  So, if something doesn't work or is broken, let me know and I'll see if I can find where I went wrong.  I added my final project folder [on GitHub](https://github.com/rpalo/vue-django-example) so you can search for discrepancies to aid in debugging.  Thanks for sticking with me!