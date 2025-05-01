import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="loading"
export default class extends Controller {
  connect() {
    this.element.addEventListener("submit", (event) => {
      const overlay = document.getElementById("loading-overlay")
      if (overlay) overlay.style.display = "flex"
    })
  }
}
