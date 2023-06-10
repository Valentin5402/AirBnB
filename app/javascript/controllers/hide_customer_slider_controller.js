import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="hide-customer-slider"
export default class extends Controller {
  static targets = ["address", "slider"]
  connect() {
    console.log(this.addressTarget)
    console.log(this.sliderTarget)
    console.log("hide customer slider")
  }

  hideCustomerSlider() {
    console.log("Succèss")
    // this.sliderTarget.classList.add("d-none")
  }

  presentCustomerSlider() {
    console.log("Succèss")
    // this.sliderTarget.classList.remove("d-none")
  }
}
