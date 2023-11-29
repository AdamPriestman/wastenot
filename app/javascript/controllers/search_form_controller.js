import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="search-form"
export default class extends Controller {
  static targets = ["servingsInput", "servingsValue", "cooktimeInput", "cooktimeValue", "ingredientInput"]

  connect() {
    this.servingsValueTarget.innerText = this.servingsInputTarget.value
    this.cooktimeValueTarget.innerText = `${this.cooktimeInputTarget.value} minutes`
  }

  displayServings(event) {
    this.servingsValueTarget.innerText = event.target.value
  }

  displayCooktime(event) {
    this.cooktimeValueTarget.innerText = `${event.target.value} minutes`
  }

  addIngredient() {
    console.log(this.ingredientInputTarget)
  }
}
