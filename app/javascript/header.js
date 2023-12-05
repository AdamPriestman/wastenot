const header = document.querySelector(".header");
let lastScroll = 0;
window.addEventListener("scroll", () => {
  let currentScroll = window.scrollY;
  console.log(header.style.top);
  if (currentScroll < lastScroll) {
    header.style.top = "0";
  } else {
    header.style.top = "-70px";
  }
  lastScroll = currentScroll;
  console.log(lastScroll);
})
