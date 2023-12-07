import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="save-url"
export default class extends Controller {
  connect() {
    // console.log("save url controller connected")

    const url = window.location.href
    // console.log(url)

    // console.log(window.location.origin)

    if (url != `${window.location.origin}/recipes`) {
      localStorage.setItem("filteredUrl", url);
    }

    const saveUrl = localStorage.getItem("filteredUrl")
    // console.log(saveUrl)
  }
}
