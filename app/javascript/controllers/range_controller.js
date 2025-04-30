// app/javascript/controllers/range_controller.js
import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="range"
export default class extends Controller {
  static targets = ["input", "value"]

  connect () {
    // initialise the label when the page loads
    this.update()
  }

  update () {
    this.valueTarget.textContent = this.inputTarget.value
  }
}
