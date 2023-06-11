import { Controller } from "@hotwired/stimulus"
import 'jquery/dist/jquery';
import 'jquery-ui-dist/jquery-ui';
import $ from 'jquery';
window.jQuery = $;
window.$ = $;

export default class extends Controller {
  static targets = ["address"]

  connect() {
    // console.log(this.address)

    const handle = this.element.querySelector('.ui-slider-handle');
    const rangeInput = document.querySelector('#range-input');

    $(this.element).slider({
      create: () => {
        $(handle).text($(this.element).slider('value'));
        rangeInput.value = $(this.element).slider('value');
      },
      slide: (event, ui) => {
        $(handle).text(ui.value);
        rangeInput.value = ui.value;
      }
    });
  }
}
