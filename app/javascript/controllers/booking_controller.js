import { Controller } from "@hotwired/stimulus"
import flatpickr from 'flatpickr';

export default class extends Controller {
  static targets = ['startDate', 'endDate', 'price', 'countofdays', 'service', 'total'];

  connect() {
    this.calculatePrice();
  }

  calculatePrice() {
    const startDate = new Date(this.startDateTarget.value);
    const endDate = new Date(this.endDateTarget.value);
    const pricePerNight = this.element.getAttribute('data-price-per-night');

    if (startDate && endDate && !isNaN(startDate) && !isNaN(endDate)) {
      const numDays = Math.ceil((endDate - startDate) / (1000 * 60 * 60 * 24));
      const priceOfFlat = numDays * pricePerNight;
      const Taxes = 10;
      const serviceFees = priceOfFlat / 20;
      const totalPrice = priceOfFlat + serviceFees + Taxes;
      this.priceTarget.innerHTML = `${priceOfFlat} €`;
      this.serviceTarget.innerHTML = `${serviceFees} €`;
      this.totalTarget.innerHTML = `${totalPrice} €`;
      this.countofdaysTarget.innerHTML = `${pricePerNight} € x ${numDays} nuits`;
    } else {
      this.priceTarget.innerHTML = '';
    }
  }
}
