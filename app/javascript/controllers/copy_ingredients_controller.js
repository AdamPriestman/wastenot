import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="copy-ingredients"
export default class extends Controller {
  static targets = ["ingredient"]

  connect() {
    console.log("copy ingredients controller connected")
    console.log(this.ingredientTarget.innerText)
  }

  ingredientsList() {
    console.log(this.ingredientTargets)
    let ingredients = []
    this.ingredientTargets.forEach((ingredient) => {
      ingredients.push(ingredient.innerText)
    })
    navigator.clipboard.writeText(ingredients.join(", "))
  }
}
