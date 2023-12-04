import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="sort-index"
export default class extends Controller {
  static targets = ["sortCheckbox"]

  connect() {
    // console.log("sort controller connected")
  }

  sortIndex(event) {
    console.log(event.target.value)
    const sortBy = event.target.value

    fetch("recipes/sort", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector("meta[name=csrf-token]").content,
      },
      body: JSON.stringify({ sortCriteria: sortBy }),
    })
      .then((response) => response.json())
      .then((data) => {
        this.renderResults(data);
      })
  }

  renderResults(data) {
    console.log(data)
    this.resultTargets.forEach((result) => {
      console.log(result)
    });
  }


}
