const nav = document.querySelector('#main-nav');
let topOfNav = nav.offsetTop;
let currentScroll;
const title = document.querySelector('#title');
const arrow = document.querySelector('.down-arrow')

function fixNav() {
  if (window.scrollY >= topOfNav) {
    document.body.style.paddingTop = nav.offsetHeight + 'px';
    document.body.classList.add('fixed-nav');
  } else {
    document.body.style.paddingTop = 0;
    document.body.classList.remove('fixed-nav');

  }
}

function offset(el) {
  var rect = el.getBoundingClientRect(),
    scrollLeft = window.pageXOffset || document.documentElement.scrollLeft,
    scrollTop = window.pageYOffset || document.documentElement.scrollTop;
  return { top: rect.top + scrollTop, left: rect.left + scrollLeft }
}

if (screen.width >= 768) {
  // only do the fancy fancy if device is desktop.
  // Mobile is too hard to work with
  //window.addEventListener('scroll', fixNav);
  //console.dir(arrow);
  arrow.addEventListener('click', function() {
    window.scroll({
      top: offset(title).top - 100,
      left: 0,
      behavior: 'smooth'
    });
  })
}
