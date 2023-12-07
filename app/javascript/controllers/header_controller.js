import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="header"
export default class extends Controller {
  static targets = ["topNavbar"];

  static values = {
    scroll: Number
  }

  connect() {
    const link = window.location.href.split("/")
    const linkValue = link[link.length - 1]
    if (linkValue === ""){
      this.topNavbarTarget.classList.remove("d-none")
    } else if (linkValue === "posts"){
      this.topNavbarTarget.classList.remove("d-none")
    } else if (linkValue === "search" ){
      this.topNavbarTarget.classList.remove("d-none")
    } else if (linkValue === "bookmarks"){
      this.topNavbarTarget.classList.remove("d-none")
    } else {
      this.topNavbarTarget.classList.add("d-none")
    }
  }

  changeNavbar() {
    let lastScroll = this.scrollValue;
    let currentScroll = window.scrollY;
    if (currentScroll < lastScroll && currentScroll > 70) {
      this.topNavbarTarget.style.top = "0";
    } if (currentScroll > lastScroll && currentScroll > 70) {
      this.topNavbarTarget.style.top = "-70px";
    }
    this.scrollValue = currentScroll;
  }
}
