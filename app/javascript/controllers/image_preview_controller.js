import { Controller } from "@hotwired/stimulus"

// Shows a local preview of the image chosen in a file input.
export default class extends Controller {
  static targets = ["input", "preview", "image"]

  disconnect() {
    this.#revoke()
  }

  show() {
    this.#revoke()
    const file = this.inputTarget.files[0]

    if (file && file.type.startsWith("image/")) {
      this.objectUrl = URL.createObjectURL(file)
      this.imageTarget.src = this.objectUrl
      this.imageTarget.alt = file.name
      this.previewTarget.hidden = false
    } else {
      this.imageTarget.removeAttribute("src")
      this.previewTarget.hidden = true
    }
  }

  #revoke() {
    if (this.objectUrl) {
      URL.revokeObjectURL(this.objectUrl)
      this.objectUrl = null
    }
  }
}
