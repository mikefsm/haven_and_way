import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.observer = new IntersectionObserver(
      ([entry]) => {
        if (entry.isIntersecting) {
          this.element.classList.add("is-visible")
          this.observer.disconnect()
        }
      },
      { threshold: 0.12 }
    )
    this.observer.observe(this.element)
  }

  disconnect() {
    this.observer.disconnect()
  }
}
