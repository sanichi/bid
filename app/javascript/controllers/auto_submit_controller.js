import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    const form = this.element;
    form.querySelectorAll(':scope select.auto-submit').forEach( (item) => {
      item.addEventListener("change", function () {
        form.requestSubmit();
      });
    });
  }
}
