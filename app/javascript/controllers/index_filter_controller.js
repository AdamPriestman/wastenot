import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="index-filter"
export default class extends Controller {
static targets = ["servingsInput", "cooktimeInput", "servingsValue", "cooktimeValue", "recipeFilter", "result"]

  connect() {
    // console.log("index filter connected")
    this.servingsValueTarget.innerText = this.servingsInputTarget.value
    this.cooktimeValueTarget.innerText = `${this.cooktimeInputTarget.value} minutes`
  }

  filterIndex(event) {
    let selectedFilters = {}
    if (event.target === this.cooktimeInputTarget) {
      this.cooktimeValueTarget.innerText = `${event.target.value} minutes`
      selectedFilters["cooktime"] =  event.target.value
      selectedFilters["servings"] =  this.servingsInputTarget.value
    } else {
      this.servingsValueTarget.innerText = event.target.value
      selectedFilters["servings"] = event.target.value
      selectedFilters["cooktime"] =  this.cooktimeInputTarget.value
    }
    console.log("-----Applied filters-----")

    if (selectedFilters) {
      this.fetchResults(selectedFilters);
    } else {
      this.fetchResults();
    }
  }

  fetchResults(filters) {
    fetch("recipes/filter", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector("meta[name=csrf-token]").content,
      },
      body: JSON.stringify({ filtersObj: filters} ),
    })
      .then((response) => response.json())
      .then((data) => {
        this.renderResults(data);
      })
      .catch(error => console.error(error));
  }

  renderResults(data) {
    console.log(data)
    console.log(this.resultTargets)
    this.resultTargets.forEach((result) => {
      const shouldShow = (data.length === 0 || data.includes(parseInt(result.dataset.id, 10)));
      shouldShow ? result.style.display = "block" : result.style.display = "none";
    });
  }
}
