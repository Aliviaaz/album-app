# Sends an album cover image to Claude (via RubyLLM) and extracts the
# artist name and album title as structured output.
#
#   result = AlbumCoverRecognizer.call(uploaded_file)
#   result.artist_name # => "Miles Davis"
#   result.album_title # => "Kind of Blue"
class AlbumCoverRecognizer
  MODEL = "gpt-5"

  Result = Data.define(:artist_name, :album_title)

  class RecognitionError < StandardError; end

  SCHEMA = {
    type: "object",
    properties: {
      identified: {
        type: "boolean",
        description: "True only if both the artist and album title could be determined from the cover."
      },
      artist_name: {
        type: "string",
        description: "The recording artist or band, as credited on the album. Empty string if unknown."
      },
      album_title: {
        type: "string",
        description: "The album's title. Empty string if unknown."
      }
    },
    required: %w[identified artist_name album_title],
    additionalProperties: false
  }.freeze

  INSTRUCTIONS = <<~PROMPT.freeze
    You identify music albums from photos of their cover art. Use text printed on
    the cover and, if there is none, your knowledge of well-known album artwork.
    Return the artist and title exactly as the album is commonly credited, with
    normal capitalization. If the image is not an album cover, or you cannot tell
    which album it is with reasonable confidence, set identified to false rather
    than guessing.
  PROMPT

  def self.call(image) = new(image).call

  def initialize(image)
    @image = image
  end

  def call
    response = RubyLLM.chat(model: MODEL, provider: :openai)
      .with_instructions(INSTRUCTIONS)
      .with_schema(SCHEMA)
      .with_thinking(effort: :low)
      .ask("Which album is this? Identify the artist and album title.", with: @image)

    if response.finish_reason == :content_filter
      raise RecognitionError, "The image couldn't be processed. Try a different photo."
    end

    data = response.parsed
    artist = data["artist_name"].to_s.strip
    title = data["album_title"].to_s.strip

    if !data["identified"] || artist.empty? || title.empty?
      raise RecognitionError, "Couldn't identify an album from that image. Try a clearer photo of the cover."
    end

    Result.new(artist_name: artist, album_title: title)
    # rescue RubyLLM::Error, JSON::ParserError => e
    #   Rails.logger.error("[AlbumCoverRecognizer] #{e.class}: #{e.message}")
    #   raise RecognitionError, "Album recognition is unavailable right now. Please try again."
  end
end
