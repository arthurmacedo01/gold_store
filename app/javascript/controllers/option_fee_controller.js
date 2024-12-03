import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["checkbox", "ctaPrice", "quantity"];
  static values = { basePrice: Number };

  connect() {
    this.updatePrice();
  }

  updatePrice() {
    // Get the base product price
    let totalPrice = this.basePriceValue;

    // Sum up fees from selected options
    this.checkboxTargets.forEach((checkbox) => {
      if (checkbox.checked) {
        totalPrice += parseFloat(checkbox.dataset.fee);
      }
    });

    // Multiply by the quantity
    const quantity = parseInt(this.quantityTarget.value, 10) || 1;
    totalPrice *= quantity;

    // Update the displayed price
    this.ctaPriceTarget.textContent = this.formatCurrency(totalPrice);
  }

  formatCurrency(amount) {
    // Format the number as currency (adjust for locale as needed)
    return new Intl.NumberFormat("en-US", {
      style: "currency",
      currency: "USD",
    }).format(amount);
  }
}
