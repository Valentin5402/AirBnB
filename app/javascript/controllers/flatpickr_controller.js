import { Controller } from "@hotwired/stimulus"
import flatpickr from "flatpickr";
// Import the rangePlugin from the flatpickr library
import rangePlugin from "flatpickr/dist/plugins/rangePlugin";

// Connects to data-controller="flatpickr"
export default class extends Controller {
  static targets = [ "startDate", "endDate" ]
  connect() {
    console.log(this.element)
    this.startDatePicker = flatpickr(this.startDateTarget, { altInput: true})
    this.endDatePicker =flatpickr(this.endDateTarget, {altInput: true})
  }
  // associerFlatpickr(event){
  //   flatpickr(event.target, {altInput: true});
  // }
  disconnect() {
    this.startDatePicker.destroy()
    this.endDatePicker.destroy()
  }
  // destroyFlatpickr() {
  //   const instance = flatpickr(this.element);
  //   if (instance && typeof instance.destroy === "function") {
  //     instance.destroy();
  //   }
  // }

}
