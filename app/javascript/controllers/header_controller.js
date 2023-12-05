import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="header"
export default class extends Controller {
  static targets = ["topNavbar"];

  static values = {
    scroll: Number
  }

  connect() {
  }

  changeNavbar() {
    let lastScroll = this.scrollValue;
    let currentScroll = window.scrollY;
    console.log(currentScroll)
    if (currentScroll < lastScroll && currentScroll > 70) {
      this.topNavbarTarget.style.top = "0";
    } if (currentScroll > lastScroll && currentScroll > 70) {
      this.topNavbarTarget.style.top = "-70px";
    }
    this.scrollValue = currentScroll;
  }
}
