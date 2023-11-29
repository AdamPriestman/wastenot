import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="modal"
export default class extends Controller {
  connect() {
    console.log("modal controller connected")
  }

  filters(){
    console.log("filters button clicked")
  }

  sort(){
    console.log("sort button clicked")
  }
}
