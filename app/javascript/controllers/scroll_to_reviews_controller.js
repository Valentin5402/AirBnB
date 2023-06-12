import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="scroll-to-reviews"
export default class extends Controller {
  static targets = ["reviews"];

  connect() {
    /* console.log("Hello from scroll-to-reviews-controller"); */
    /* this.scroll(); */
  }

  scroll() {
    /* console.log(this.element); */
    /* console.log("I want to scroll !");
    console.log(this.linksTarget); */
    /* console.log(this.reviewsTarget); */
    this.reviewsTarget.scrollIntoView();
  }
}
