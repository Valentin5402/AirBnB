import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="scroll-to-reviews"
export default class extends Controller {
  static targets = ["links", "reviews"];

  connect() {
    console.log("Hello from scroll-to-reviews-controller");

  }

  scroll() {
    console.log(this.event);
    // qu'est-ce que je dois mettre en entrée pour scroller ???
    console.log("I want to scroll !");
    console.log(this.reviewsTarget);
  }
}
