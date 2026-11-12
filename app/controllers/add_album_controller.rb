class AddAlbumController < ApplicationController
  ALLOWED_IMAGE_TYPES = %w[image/jpeg image/png image/gif image/webp].freeze
  MAX_IMAGE_SIZE = 5.megabytes

  # GET /add-album
  def index
    @album = Album.new
  end

  # POST /add-album
  def create
    @album = Album.new
    image = params.dig(:album, :cover_image)

    if (error = image_error(image))
      return render_failure(error)
    end

    result = AlbumCoverRecognizer.call(image)

    Album.transaction do
      artist = Artist.where("LOWER(name) = ?", result.artist_name.downcase).first ||
               Artist.create!(name: result.artist_name)
      @album = Album.create!(title: result.album_title, artist: artist)
    end

    respond_to do |format|
      format.html { redirect_to @album, notice: "Added \"#{@album.title}\" by #{@album.artist.name}." }
      format.json { render "albums/show", status: :created, location: @album }
    end
  rescue AlbumCoverRecognizer::RecognitionError => e
    render_failure(e.message)
  rescue ActiveRecord::RecordInvalid => e
    render_failure(e.record.errors.full_messages.to_sentence)
  end

  private
    def image_error(image)
      return "Please choose an image of the album cover." unless image.respond_to?(:content_type)
      return "Image must be a JPEG, PNG, GIF, or WebP." unless ALLOWED_IMAGE_TYPES.include?(image.content_type)
      "Image must be smaller than 5 MB." if image.size > MAX_IMAGE_SIZE
    end

    def render_failure(message)
      @album.errors.add(:base, message)
      respond_to do |format|
        format.html { render :index, status: :unprocessable_content }
        format.json { render json: @album.errors, status: :unprocessable_content }
      end
    end
end
