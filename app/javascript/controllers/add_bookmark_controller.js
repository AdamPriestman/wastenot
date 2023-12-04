import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="add-bookmark"
export default class extends Controller {
  static targets = ["bookmarkFalse", "bookmarkTrue"]
  connect() {
  }

  create_bookmark(event){
    event.preventDefault();
    console.log("bookmark icon clicked")

    fetch(this.bookmarkFalseTarget.action, {
    method: "POST",
    headers: { "Accept": "application/json" },
    body: new FormData(this.bookmarkFalseTarget)
    })

    .then(response => response.json())
    .then((data) => {
      console.log(data)
    })


}
// delete_bookmark(event) {
//   event.preventDefault();
// }
}
