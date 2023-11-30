import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="search-form"
export default class extends Controller {
  static targets = ["servingsInput", "servingsValue", "cooktimeInput", "cooktimeValue", "ingredientInput", "ingredientFormTwo", "ingredientFormThree", "ingredientButtonTwo", "ingredientButtonThree"]

  connect() {
    this.servingsValueTarget.innerText = this.servingsInputTarget.value
    this.cooktimeValueTarget.innerText = `${this.cooktimeInputTarget.value} minutes`
  }

  displayServings(event) {
    if (event.target.value === "8") {
      this.servingsValueTarget.innerText = "8+"
    } else {
      this.servingsValueTarget.innerText = event.target.value
    }
  }

  displayCooktime(event) {
    this.cooktimeValueTarget.innerText = `${event.target.value} minutes`
  }

  addIngredientTwo() {
    this.ingredientButtonTwoTarget.classList.add("d-none")
    this.ingredientFormTwoTarget.classList.remove("d-none")
  }

  addIngredientThree() {
    this.ingredientButtonThreeTarget.classList.add("d-none")
    this.ingredientFormThreeTarget.classList.remove("d-none")
  }

  revealButtonTwo() {
    this.ingredientButtonTwoTarget.classList.remove("d-none")
  }

  revealButtonThree() {
    this.ingredientButtonThreeTarget.classList.remove("d-none")
  }
}
