import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["updateButton"]

  submitForm(event) {
    // Find the form element containing the changed input
    const form = event.target.closest("form");
    if (form) {
      form.requestSubmit(); // Submits the form
    }
  }

  setQuantityToZero(event) {
    const quantityField = this.element.querySelector(`#${event.params.quantityId}`);
    if (quantityField) {
      quantityField.value = "0";
    }
  }

  disableUpdateButton() {
    if (this.hasUpdateButtonTarget) {
      this.updateButtonTarget.setAttribute("disabled", true);
    }
  }
}
