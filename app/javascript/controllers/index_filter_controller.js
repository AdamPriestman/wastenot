import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="index-filter"
export default class extends Controller {
static targets = ["servingsInput", "cooktimeInput", "servingsLabel", "cooktimeValue", "result", "list", "form", "veganCheckbox", "vegetarianCheckbox", "glutenCheckbox", "dairyCheckbox", "radioCheckbox", "noResults", "listCount"]
static values = {
  ingredients: Object
}

  connect() {
    const link = window.location.href.split("/")
    const linkVal = link[link.length -1]
    if (this.servingsInputTarget.value) {
      // console.log("there is a value")
      // console.log(this.servingsInputTarget.value)
      this.servingsLabelTarget.innerText = `${this.servingsInputTarget.value}`
      this.cooktimeValueTarget.innerText = `${this.cooktimeInputTarget.value} minutes`
    } else if (linkVal === "recipes") {
      // console.log("its empty")
      this.servingsLabelTarget.value = 3
      this.servingsLabelTarget.innerText = "3"
      this.cooktimeValueTarget.value = 50
      this.cooktimeValueTarget.innerText = "50 minutes"
    }
  }

  update(event) {
    let selectedFilters = {}
    if (event.target === this.cooktimeInputTarget) {
      if (event.target.value >= 100) {
        this.cooktimeValueTarget.innerText = "100+ minutes"
      } else {
        this.cooktimeValueTarget.innerText = `${event.target.value} minutes`
      }
    } else if (event.target === this.servingsInputTarget) {
      if (event.target.value >= 8) {
        this.servingsLabelTarget.innerText = "8+"
      } else {
        this.servingsLabelTarget.innerText = event.target.value
      }
    }

    if (this.veganCheckboxTarget.checked) {
      this.veganCheckboxTarget.value = 1
    } else {
      this.veganCheckboxTarget.value = 0
    }

    if (this.vegetarianCheckboxTarget.checked) {
      this.vegetarianCheckboxTarget.value = 1
    } else {
      this.vegetarianCheckboxTarget.value = 0
    }

    if (this.glutenCheckboxTarget.checked) {
      this.glutenCheckboxTarget.value = 1
    } else {
      this.glutenCheckboxTarget.value = 0
    }

    if (this.dairyCheckboxTarget.checked) {
      this.dairyCheckboxTarget.value = 1
    } else {
      this.dairyCheckboxTarget.value = 0
    }

    let sortBy = ""
    this.radioCheckboxTargets.forEach((radio) => {
      if (radio.checked) {
        sortBy = radio.value
      }
    })

    const url = `${this.formTarget.action}?ingredient1=${(this.ingredientsValue["ingredient1"] === 0) ? "" : this.ingredientsValue["ingredient1"]}&ingredient2=${(this.ingredientsValue["ingredient2"] === 0) ? "" : this.ingredientsValue["ingredient2"]}&ingredient3=${(this.ingredientsValue["ingredient3"] === 0)  ? "" : this.ingredientsValue["ingredient3"]}&cooktime=${this.cooktimeInputTarget.value}&servings=${this.servingsInputTarget.value}&vegan=${this.veganCheckboxTarget.value}&vegetarian=${this.vegetarianCheckboxTarget.value}&gluten_free=${this.glutenCheckboxTarget.value}&dairy_free=${this.dairyCheckboxTarget.value}&sortBy=${sortBy}`

    fetch(url, {headers: {"Accept": "text/plain"}})
      .then(response => response.text())
      .then ((data) => {
        this.listTarget.outerHTML = data
      })
  }
}
