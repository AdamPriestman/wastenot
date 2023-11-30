import { Controller } from "@hotwired/stimulus"
import TomSelect from "tom-select"

// Connects to data-controller="search-form"
export default class extends Controller {
  static targets = ["servingsInput", "servingsValue", "cooktimeInput", "cooktimeValue", "ingredientInput", "ingredientFormTwo", "ingredientFormThree", "ingredientButtonTwo", "ingredientButtonThree"]

  connect() {
    this.servingsValueTarget.innerText = this.servingsInputTarget.value
    this.cooktimeValueTarget.innerText = `<${this.cooktimeInputTarget.value} minutes`
    new TomSelect("#ingredient1",{
      create: false,
      sortField: {
        field: "text",
        direction: "asc"
      }
    });

    new TomSelect("#ingredient2",{
      create: false,
      sortField: {
        field: "text",
        direction: "asc"
      }
    });

    new TomSelect("#ingredient3",{
      create: false,
      sortField: {
        field: "text",
        direction: "asc"
      }
    });
  }

  displayServings(event) {
    if (event.target.value === "8") {
      this.servingsValueTarget.innerText = "8+"
    } else {
      this.servingsValueTarget.innerText = event.target.value
    }
  }

  displayCooktime(event) {
    this.cooktimeValueTarget.innerText = `<${event.target.value} minutes`
  }

  addIngredientTwo() {
    this.ingredientButtonTwoTarget.outerHTML = ""
    this.ingredientFormTwoTarget.classList.remove("d-none")
  }

  addIngredientThree() {
    this.ingredientButtonThreeTarget.outerHTML = ""
    this.ingredientFormThreeTarget.classList.remove("d-none")
  }

  revealButtonTwo() {
    this.ingredientButtonTwoTarget.classList.remove("d-none")
  }

  revealButtonThree() {
    this.ingredientButtonThreeTarget.classList.remove("d-none")
  }
}
