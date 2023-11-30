import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="index-filter"
export default class extends Controller {
static targets = ["servingsInput", "cooktimeInput", "servingsValue", "cooktimeValue", "recipeFilter", "result"]

  connect() {
    console.log("index filter connected")
    this.servingsValueTarget.innerText = this.servingsInputTarget.value
    this.cooktimeValueTarget.innerText = `${this.cooktimeInputTarget.value} minutes`
  }

  filterIndex(event) {
    let selectedFilters = []
    if (event.target === this.cooktimeInputTarget) {
      this.cooktimeValueTarget.innerText = `${event.target.value} minutes`
      selectedFilters.push({ cooktime:event.target.value })
      selectedFilters.push({ servings:this.servingsInputTarget.value })
    } else {
      this.servingsValueTarget.innerText = event.target.value
      selectedFilters.push({ servings: event.target.value })
      selectedFilters.push({ cooktime: this.cooktimeInputTarget.value })
    }
    console.log("-----Applied filters-----")
    console.log(selectedFilters)
    console.log(selectedFilters.constructor === Array)
    console.log(selectedFilters[0].constructor === Object)

    if (selectedFilters.length > 0) {
      this.fetchResults(selectedFilters);
    } else {
      this.fetchResults();
    }
  }

  fetchResults(filters = []) {

    const filtersObj = {filtersKey: filters}
    fetch("recipes/filter", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector("meta[name=csrf-token]").content,
      },
      body: JSON.stringify({ filtersObj }),
    })
      .then((response) => response.json())
      .then((data) => {
        this.renderResults(data);
      })
      .catch(error => console.error(error));
  }

  renderResults(data) {
    console.log(data)
    this.resultTargets.forEach((result) => {
      const shouldShow = data.length === 0 || data.includes(parseInt(result.dataset.id, 10));
      result.style.display = shouldShow ? "block" : "none";
    });
  }
}
