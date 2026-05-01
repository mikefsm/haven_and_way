import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["slide", "dot"]

  connect() {
    this.currentIndex = 0
    this.timer = setInterval(() => this.advance(), 5000)
  }

  disconnect() {
    clearInterval(this.timer)
  }

  advance() {
    this.goToIndex((this.currentIndex + 1) % this.slideTargets.length)
  }

  goTo(event) {
    const index = parseInt(event.currentTarget.dataset.index)
    clearInterval(this.timer)
    this.timer = setInterval(() => this.advance(), 5000)
    this.goToIndex(index)
  }

  goToIndex(index) {
    this.slideTargets[this.currentIndex].classList.remove("is-active")
    if (this.hasDotTarget) this.dotTargets[this.currentIndex]?.classList.remove("is-active")
    this.currentIndex = index
    this.slideTargets[this.currentIndex].classList.add("is-active")
    if (this.hasDotTarget) this.dotTargets[this.currentIndex]?.classList.add("is-active")
  }
}
