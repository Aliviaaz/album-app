# Asks the model (via RubyLLM) for the tracklist of an album, using the
# album title and artist name.
#
#   AlbumTracklistFetcher.call(album)
#   # => ["So What", "Freddie Freeloader", "Blue in Green", ...]
#
# Returns song names only; it does not create Song records.
class AlbumTracklistFetcher
  MODEL = "gpt-5"

  class LookupError < StandardError; end

  SCHEMA = {
    type: "object",
    properties: {
      identified: {
        type: "boolean",
        description: "True only if you know this specific album and its tracklist."
      },
      songs: {
        type: "array",
        description: "Song titles in track order. Empty if unknown.",
        items: { type: "string" }
      }
    },
    required: %w[identified songs],
    additionalProperties: false
  }.freeze

  INSTRUCTIONS = <<~PROMPT.freeze
    You list the tracks on music albums. Given an artist and album title, return
    the song titles from the album's original standard edition, in track order,
    with normal capitalization. Leave out track numbers, durations, and featured
    artist credits. Do not include bonus tracks from deluxe or reissue editions.
    If you don't know the album or aren't confident of its tracklist, set
    identified to false rather than guessing.
  PROMPT

  def self.call(album) = new(album).call

  def initialize(album)
    @album = album
  end

  def call
    title = @album.title.to_s.strip
    artist = @album.artist&.name.to_s.strip
    raise LookupError, "The album needs a title and an artist." if title.empty? || artist.empty?

    response = RubyLLM.chat(model: MODEL, provider: :openai)
      .with_instructions(INSTRUCTIONS)
      .with_schema(SCHEMA)
      .with_thinking(effort: :low)
      .ask("Artist: #{artist}\nAlbum: #{title}\n\nList the songs on this album.")

    data = response.parsed
    songs = Array(data["songs"]).map { |s| s.to_s.strip }.reject(&:empty?)

    if !data["identified"] || songs.empty?
      raise LookupError, "Couldn't find a tracklist for \"#{title}\" by #{artist}."
    end

    songs
  end
end
