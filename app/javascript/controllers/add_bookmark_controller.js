import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="add-bookmark"
export default class extends Controller {
  static targets = ["id", "bookmarkFalse", "bookmarkTrue", "icon"]
  connect() {
    // console.log(this.idTarget.innerText)
  }

  create_bookmark(event){
    event.preventDefault();
    // console.log("bookmark icon clicked")
    const recipeId = this.idTarget.innerHTML
    console.log(recipeId)
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
      this.iconTarget.innerHTML = data
    })

  }
// delete_bookmark(event) {
//   event.preventDefault();
}
