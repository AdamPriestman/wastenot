import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="toggle"
export default class extends Controller {
  static targets = ["bookmarkFalse", "bookmarkTrue"]
  connect() {
    // console.log("connected")
  }

  bookmark(event){
    event.preventDefault();
    console.log("bookmark icon clicked")
    this.bookmarkFalseTarget.classList.toggle("d-none");
    this.bookmarkTrueTarget.classList.toggle("d-none");
  }
}
