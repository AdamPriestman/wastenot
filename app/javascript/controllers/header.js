const header = document.querySelector(".header");
let lastScroll = 0;
window.addEventListener("scroll", () => {
  let currentScroll = window.scrollY;
  if (currentScroll < lastScroll) {
    header.style.top = "0";
  } else {
    header.style.top = "-50px";
  }
  lastScroll = currentScroll;
})
