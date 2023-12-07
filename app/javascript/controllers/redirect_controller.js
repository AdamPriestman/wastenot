import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="redirect"
export default class extends Controller {
  connect() {
    console.log("redirect controller connected")
  }

  redirect() {
    const saveUrl = localStorage.getItem("filteredUrl")
    window.location.replace(saveUrl);
  }
}
