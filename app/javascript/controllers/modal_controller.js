import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="modal"
export default class extends Controller {
  static targets = ["filters", "filtersDiv", "card"]
  connect() {
    console.log("modal controller connected")
  }

  filters() {
    this.filtersTarget.style.display = "block"
    this.cardTargets.forEach(element => {
      element.style.pointerEvents = "none";
    });


  }

  closeFilters() {
    this.filtersTarget.style.display = "none"
    this.cardTargets.forEach(element => {
      element.style.pointerEvents = "auto";
    });
  }

  sort() {
    console.log("sort button clicked")
  }
}
