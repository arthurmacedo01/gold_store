import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["checkbox", "ctaPrice", "quantity"];
  static values = { basePrice: Number };

  connect() {
    // Validate all variant-selection groups on page load
    this.validateAll();

    // Update the price on page load
    this.updatePrice();
  }

  updatePrice() {
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

  toggleExclusive(event) {
    const clickedCheckbox = event.target;

    // Find all checkboxes for the same option_type
    const optionTypeCheckBoxes = this.checkboxTargets.filter((checkbox) => {
      const clickedOptionType = clickedCheckbox.closest(".variant-selection");
      const currentOptionType = checkbox.closest(".variant-selection");
      return clickedOptionType === currentOptionType;
    });

    // Deselect all other checkboxes in the same option_type group
    optionTypeCheckBoxes.forEach((checkbox) => {
      if (checkbox !== clickedCheckbox) {
        checkbox.checked = false;
      }
    });

    // Validate the current group
    this.validateSelection(optionTypeCheckBoxes);

    // Update the price
    this.updatePrice();
  }

  validateAll() {
    // Group checkboxes by their variant-selection container
    const variantSelections = Array.from(
      new Set(this.checkboxTargets.map((checkbox) => checkbox.closest(".variant-selection")))
    );

    // Validate each group
    variantSelections.forEach((variantSelection) => {
      const checkboxes = this.checkboxTargets.filter(
        (checkbox) => checkbox.closest(".variant-selection") === variantSelection
      );
      this.validateSelection(checkboxes);
    });
  }

  validateSelection(optionTypeCheckBoxes) {
    // Check if at least one checkbox is selected
    const isSelected = optionTypeCheckBoxes.some((checkbox) => checkbox.checked);

    if (!isSelected) {
      // Select the first checkbox as a fallback
      optionTypeCheckBoxes[0].checked = true;
    }
  }

  formatCurrency(amount) {
    return new Intl.NumberFormat("en-US", {
      style: "currency",
      currency: "USD",
    }).format(amount);
  }
}
