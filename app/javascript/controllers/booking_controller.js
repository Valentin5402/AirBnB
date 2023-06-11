import { Controller } from "@hotwired/stimulus"
import flatpickr from 'flatpickr';

export default class extends Controller {
  static targets = ['startDate', 'endDate', 'price', 'countofdays', 'service', 'total', 'infos'];

  connect() {
    this.calculatePrice();
  }

  calculatePrice() {

    const startDate = new Date(this.startDateTarget.value);
    const endDate = new Date(this.endDateTarget.value);
    const pricePerNight = this.element.getAttribute('data-price-per-night');

    if (startDate && endDate && !isNaN(startDate) && !isNaN(endDate)) {
      if (startDate >= endDate) {
        console.log("la date de départ doit être après la date d'arrivée");
        this.infosTarget.classList.add("d-none");
      } else {
        this.infosTarget.classList.remove("d-none");
        const numDays = Math.ceil((endDate - startDate) / (1000 * 60 * 60 * 24));
        const priceOfFlat = numDays * pricePerNight;
        const Taxes = 10;
        const serviceFees = priceOfFlat / 20;
        const totalPrice = priceOfFlat + serviceFees + Taxes;
        this.priceTarget.innerHTML = `${priceOfFlat} €`;
        this.serviceTarget.innerHTML = `${serviceFees} €`;
        this.totalTarget.innerHTML = `${totalPrice} €`;
        if (numDays === 1) {
          this.countofdaysTarget.innerHTML = `${pricePerNight} € x ${numDays} nuit`;
        } else {
          this.countofdaysTarget.innerHTML = `${pricePerNight} € x ${numDays} nuits`;
        }
      }
    } else {
      this.priceTarget.innerHTML = '';
    }
  }
}
