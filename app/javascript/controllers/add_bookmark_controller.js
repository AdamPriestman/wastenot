import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="add-bookmark"
export default class extends Controller {
  static targets = ["bookmark", "switch", "recipe"]
  static values = {
    id: String,
    recipe: String
  }
  connect() {
    const link = window.location.href.split("/")
    const recipes = this.recipeTargets
    console.log(recipes)
    const recipeId = this.recipeValue
    console.log(recipeValue)
    const iconValue = (link[link.length - 1])
    console.log(iconValue)
    if (iconValue === `${recipeId}`){
      this.switchTarget.classList.add("green")
      this.switchTarget.classList.remove("white")
    } else {
      this.switchTarget.classList.remove("green")
      this.switchTarget.classList.add("white")
    }
  }

  create_bookmark(event){
    event.preventDefault();
    // console.log("bookmark icon clicked")
    const recipeId = this.recipeValue
    // console.log(recipeId)
    const url = `/recipes/${recipeId}/bookmarks`;
    const options = {
      method: "POST",
      headers: {
      "Accept": "text/plain",
      "X-CSRF-Token": document.querySelector("meta[name=csrf-token]").content,
      },
      // body: { recipe_id: recipeId}
      body: JSON.stringify({ "recipe_id": recipeId })
    }

    fetch(url, options)
    .then(response => response.text())
    .then((data) => {
      console.log(data)
      this.element.outerHTML = data
    })

  }
  delete_bookmark(event) {
    event.preventDefault();
    const url = `/bookmarks/${this.idValue}`
    // const bookmark = this.idValue
    const options =  {
      method: "DELETE",
      headers: {
      "Accept": "text/plain",
      "X-CSRF-Token": document.querySelector("meta[name=csrf-token]").content,
      },
      // body: JSON.stringify({ bookmark: bookmark })
    }

    fetch(url, options)
      .then(response => response.text())
      .then((data) => {

        this.element.outerHTML = data
      })
  }
}
