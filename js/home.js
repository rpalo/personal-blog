const nav = document.querySelector('#main-nav');
let topOfNav = nav.offsetTop;
let currentScroll;

function fixNav() {
  if (window.scrollY >= topOfNav) {
    document.body.style.paddingTop = nav.offsetHeight + 'px';
    document.body.classList.add('fixed-nav');
  } else {
    document.body.style.paddingTop = 0;
    document.body.classList.remove('fixed-nav');

  }
}

if (screen.width >= 768) {
  // only do the fancy fancy if device is desktop.
  // Mobile is too hard to work with
  window.addEventListener('scroll', fixNav);

}
