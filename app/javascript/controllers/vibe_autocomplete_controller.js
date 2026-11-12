import { Controller } from "@hotwired/stimulus"

// Suggests existing vibes for the token currently being typed in a
// space-separated, quote-aware list like: "late night" chill up|
export default class extends Controller {
  static targets = ["input", "list"]
  static values = { vibes: Array }

  connect() {
    this.matches = []
    this.activeIndex = -1
  }

  update() {
    const { fragment } = this.currentToken()
    const query = fragment.toLowerCase()
    const taken = new Set(this.enteredVibes().map((v) => v.toLowerCase()))

    this.matches = query
      ? this.vibesValue.filter((v) => v.toLowerCase().includes(query) && !taken.has(v.toLowerCase())).slice(0, 8)
      : []
    this.activeIndex = this.matches.length ? 0 : -1
    this.render()
  }

  navigate(event) {
    if (this.listTarget.hidden) return

    switch (event.key) {
      case "ArrowDown":
        event.preventDefault()
        this.activeIndex = (this.activeIndex + 1) % this.matches.length
        this.render()
        break
      case "ArrowUp":
        event.preventDefault()
        this.activeIndex = (this.activeIndex - 1 + this.matches.length) % this.matches.length
        this.render()
        break
      case "Enter":
      case "Tab":
        if (this.activeIndex >= 0) {
          event.preventDefault()
          this.choose(this.matches[this.activeIndex])
        }
        break
      case "Escape":
        this.hide()
        break
    }
  }

  hide() {
    this.listTarget.hidden = true
    this.inputTarget.setAttribute("aria-expanded", "false")
  }

  choose(vibe) {
    const { start } = this.currentToken()
    const before = this.inputTarget.value.slice(0, start)
    this.inputTarget.value = `${before}"${vibe}" `
    this.inputTarget.focus()
    this.hide()
  }

  // Text from the start of the token being typed to the cursor (end of input).
  currentToken() {
    const value = this.inputTarget.value
    const quotes = (value.match(/"/g) || []).length
    const start = quotes % 2 === 1 ? value.lastIndexOf('"') : value.search(/\S*$/)
    return { start, fragment: value.slice(start).replace(/^"/, "").trim() }
  }

  enteredVibes() {
    const done = this.inputTarget.value.slice(0, this.currentToken().start)
    return [...done.matchAll(/"([^"]*)"|(\S+)/g)].map((m) => (m[1] ?? m[2]).trim())
  }

  render() {
    this.listTarget.replaceChildren(
      ...this.matches.map((vibe, i) => {
        const li = document.createElement("li")
        li.textContent = vibe
        li.setAttribute("role", "option")
        li.setAttribute("aria-selected", i === this.activeIndex)
        li.className = `cursor-pointer px-3 py-2 ${i === this.activeIndex ? "bg-indigo-50 text-indigo-700" : "text-slate-700 hover:bg-slate-50"}`
        // mousedown fires before the input's blur, so the click isn't lost.
        li.addEventListener("mousedown", (e) => {
          e.preventDefault()
          this.choose(vibe)
        })
        return li
      })
    )
    const open = this.matches.length > 0
    this.listTarget.hidden = !open
    this.inputTarget.setAttribute("aria-expanded", String(open))
  }
}
