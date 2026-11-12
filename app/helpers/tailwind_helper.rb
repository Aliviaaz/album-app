module TailwindHelper
  # Shared Tailwind class sets. Kept as full, literal strings so Tailwind's
  # source scanner can detect every class.
  BUTTON_BASE = "inline-flex items-center justify-center gap-2 rounded-lg px-4 py-2 text-sm font-semibold shadow-xs transition-colors focus-visible:outline-2 focus-visible:outline-offset-2 cursor-pointer".freeze

  BUTTON_VARIANTS = {
    primary: "bg-indigo-600 text-white hover:bg-indigo-500 focus-visible:outline-indigo-600",
    secondary: "bg-white text-slate-900 ring-1 ring-inset ring-slate-300 hover:bg-slate-50 focus-visible:outline-slate-400",
    danger: "bg-white text-red-600 ring-1 ring-inset ring-red-200 hover:bg-red-50 focus-visible:outline-red-600"
  }.freeze

  INPUT_CLASSES = "block w-full rounded-lg border-0 bg-white px-3 py-2 text-slate-900 shadow-xs ring-1 ring-inset ring-slate-300 placeholder:text-slate-400 focus:ring-2 focus:ring-inset focus:ring-indigo-600 sm:text-sm".freeze
  LABEL_CLASSES = "block text-sm font-medium text-slate-900".freeze
  CHECKBOX_CLASSES = "size-4 rounded border-slate-300 text-indigo-600 accent-indigo-600 focus:ring-indigo-600".freeze

  NAV_ITEMS = [
    [ "Albums", :albums_path, "albums" ],
    [ "Artists", :artists_path, "artists" ],
    [ "Songs", :songs_path, "songs" ],
    [ "Vibes", :vibes_path, "vibes" ]
  ].freeze

  def button_classes(variant = :primary)
    "#{BUTTON_BASE} #{BUTTON_VARIANTS.fetch(variant)}"
  end

  def input_classes = INPUT_CLASSES
  def label_classes = LABEL_CLASSES
  def checkbox_classes = CHECKBOX_CLASSES

  def nav_link(label, path, section)
    active = controller_name == section
    classes = if active
      "rounded-md bg-indigo-50 px-3 py-2 text-sm font-semibold text-indigo-700"
    else
      "rounded-md px-3 py-2 text-sm font-medium text-slate-600 hover:bg-slate-100 hover:text-slate-900"
    end
    link_to label, path, class: classes, aria: { current: (active ? "page" : nil) }
  end

  # First letter(s) of a name for avatar / cover placeholders.
  def initials(text)
    text.to_s.split.first(2).map { |word| word[0] }.join.upcase.presence || "?"
  end

  # Deterministic gradient per record so covers look varied but stable.
  COVER_GRADIENTS = [
    "from-indigo-500 to-purple-600",
    "from-rose-500 to-orange-400",
    "from-emerald-500 to-teal-600",
    "from-sky-500 to-blue-600",
    "from-amber-400 to-pink-500",
    "from-fuchsia-500 to-violet-600"
  ].freeze

  def cover_gradient(record)
    COVER_GRADIENTS[record.id.to_i % COVER_GRADIENTS.size]
  end
end
