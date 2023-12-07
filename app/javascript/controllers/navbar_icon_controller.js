import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="navbar-icon"
export default class extends Controller {
  static targets = ["home", "feed", "search", "bookmark"]
  connect() {
    const link = window.location.href.split("/")
    const iconValue = (link[link.length - 1])
    if (iconValue === "posts"){
      this.feedTarget.classList.add("active")
    } else if (iconValue === "search" ){
      this.searchTarget.classList.add("active")
    } else if (iconValue === "bookmarks"){
      this.bookmarkTarget.classList.add("active")
    } else if (iconValue === "") {
      console.log("no icons green")
      this.searchTarget.classList.remove("active")
    } else {
      this.searchTarget.classList.add("active")
    }
  }
}
