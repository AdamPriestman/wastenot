import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="index-filter"
export default class extends Controller {
static targets = ["servingsInput", "cooktimeInput", "servingsLabel", "cooktimeValue", "recipeFilter", "result", "checkbox", "list", "form", "veganCheckbox", "vegetarianCheckbox", "glutenCheckbox", "dairyCheckbox", "ingredientOne"]
static values = {
  ingredients: Object
}

  connect() {
    this.servingsLabelTarget.innerText = this.servingsInputTarget.value
    this.cooktimeValueTarget.innerText = `<${this.cooktimeInputTarget.value} minutes`
  }

  filterIndex(event) {
    let selectedFilters = {}
    if (event.target === this.cooktimeInputTarget) {
      this.cooktimeValueTarget.innerText = `<${event.target.value} minutes`
      selectedFilters["cooktime"] =  event.target.value
      selectedFilters["servings"] =  this.servingsInputTarget.value
    } else if (event.target === this.servingsInputTarget) {
      if (event.target.value >= 8) {
        this.servingsLabelTarget.innerText = "8+"
      } else {
        this.servingsLabelTarget.innerText = event.target.value
      }
      selectedFilters["servings"] = event.target.value
      selectedFilters["cooktime"] =  this.cooktimeInputTarget.value
    } else {
      selectedFilters["servings"] =  this.servingsInputTarget.value
      selectedFilters["cooktime"] =  this.cooktimeInputTarget.value
      const checkboxes = this.checkboxTargets
      checkboxes.forEach((checkbox) => {
        if (checkbox.checked) {
          selectedFilters[`${checkbox.value}`] = true
        }
      })
    }

    console.log(selectedFilters)
    console.log("-----Applied filters-----")

    if (selectedFilters) {
      this.fetchResults(selectedFilters);
    } else {
      this.fetchResults();
    }
  }


  fetchResults(filters) {

    const formData = new FormData()
    formData.append("filtersObj", filters)
    // console.log(formData)
    fetch("recipes/filter", {
      method: "POST",
      headers: {
        "Content-Type": "application/text",
        "X-CSRF-Token": document.querySelector("meta[name=csrf-token]").content,
      },
      body: formData,
    })
      .then((response) => response.text())
      .then((data) => {
        // console.log(data)
        this.listTarget.outerHTML = data;
      })
      .catch(error => console.error(error));
  }

  update(event) {
    let selectedFilters = {}
    if (event.target === this.cooktimeInputTarget) {
      this.cooktimeValueTarget.innerText = `<${event.target.value} minutes`
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


    // console.log(this.ingredientsValue["ingredient1"])
    if (this.ingredientsValue["ingredient1"] === 0) {
      this.ingredientsValue["ingredient1"] = ""
    } else if (this.ingredientsValue["ingredient2"] === 0) {
      console.log("ingredient 2 is 0")
      this.ingredientsValue["ingredient2"] = ""
      console.log(this.ingredientsValue["ingredient2"])
    } else if (this.ingredientsValue["ingredient3"] === 0) {
      this.ingredientsValue["ingredient3"] = ""
    }
    console.log(this.ingredientsValue)



    const url = `${this.formTarget.action}?ingredient1=${(this.ingredientsValue["ingredient1"] === 0) ? "" : this.ingredientsValue["ingredient1"]}&ingredient2=${(this.ingredientsValue["ingredient2"] === 0) ? "" : this.ingredientsValue["ingredient2"]}&ingredient3=${(this.ingredientsValue["ingredient3"] === 0)  ? "" : this.ingredientsValue["ingredient3"]}&cooktime=${this.cooktimeInputTarget.value}&servings=${this.servingsInputTarget.value}&vegan=${this.veganCheckboxTarget.value}&vegetarian=${this.vegetarianCheckboxTarget.value}&gluten_free=${this.glutenCheckboxTarget.value}&dairy_free=${this.dairyCheckboxTarget.value}`
    console.log(url)
    fetch(url, {headers: {"Accept": "text/plain"}})
      .then(response => response.text())
      .then ((data) => {
        this.listTarget.outerHTML = data
      })
  }
}
