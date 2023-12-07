import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="modal"
export default class extends Controller {
  static targets = ["filters", "filtersDiv", "card", "sort", "indexPage"]
  connect() {
    // console.log("modal controller connected")
  }

  filters() {
    // this.filtersTarget.style.display = "block"
    this.filtersTarget.classList.toggle("closed")
    this.cardTargets.forEach(element => {
      element.style.pointerEvents = "none";
    });
  }

  closeFilters() {
    this.filtersTarget.classList.toggle("closed")
    this.cardTargets.forEach(element => {
      element.style.pointerEvents = "auto";
    });
  }
}
