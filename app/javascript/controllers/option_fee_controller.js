import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["select", "ctaPrice", "quantity"];
  static values = { basePrice: Number };

  connect() {
    // Update the price on page load
    this.updatePrice();
  }

  updatePrice() {
    let totalPrice = this.basePriceValue;

    // Get the selected option from the select element
    this.selectTargets.forEach((select) => {
      const selectedOption = select.options[select.selectedIndex];
      if (selectedOption && selectedOption.dataset.fee) {
        totalPrice += parseFloat(selectedOption.dataset.fee);
      }
    });

    // Multiply by the quantity
    const quantity = parseInt(this.quantityTarget.value, 10) || 1;
    totalPrice *= quantity;

    // Update the displayed price
    this.ctaPriceTarget.textContent = this.formatCurrency(totalPrice);
  }

  formatCurrency(amount) {
    return new Intl.NumberFormat("en-US", {
      style: "currency",
      currency: "USD",
    }).format(amount);
  }
}
