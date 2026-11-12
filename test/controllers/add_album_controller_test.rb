require "test_helper"

class AddAlbumControllerTest < ActionDispatch::IntegrationTest
  setup do
    @cover = fixture_file_upload("cover.png", "image/png")
  end

  test "should get add-album page" do
    get add_album_url
    assert_response :success
    assert_select "input[type=file][name='album[cover_image]']"
  end

  test "creates album and new artist from recognized cover" do
    with_recognizer(->(_) { AlbumCoverRecognizer::Result.new(artist_name: "Zed Unique Artist", album_title: "Kind of Blue") }) do
      assert_difference(["Album.count", "Artist.count"], 1) do
        post add_album_url, params: { album: { cover_image: @cover } }
      end
    end
    album = Album.last
    assert_equal "Kind of Blue", album.title
    assert_equal "Zed Unique Artist", album.artist.name
    assert_redirected_to album_url(album)
  end

  test "reuses existing artist case-insensitively" do
    artist = Artist.create!(name: "Zed Existing Artist")
    with_recognizer(->(_) { AlbumCoverRecognizer::Result.new(artist_name: "zed existing artist", album_title: "Bitches Brew") }) do
      assert_no_difference("Artist.count") do
        assert_difference("Album.count", 1) { post add_album_url, params: { album: { cover_image: @cover } } }
      end
    end
    assert_equal artist, Album.last.artist
  end

  test "shows error when the album can't be identified" do
    with_recognizer(->(_) { raise AlbumCoverRecognizer::RecognitionError, "Couldn't identify an album" }) do
      assert_no_difference("Album.count") { post add_album_url, params: { album: { cover_image: @cover } } }
    end
    assert_response :unprocessable_content
    assert_match "Couldn&#39;t identify an album", response.body
  end

  test "rejects missing image without calling the model" do
    with_recognizer(->(_) { flunk "recognizer should not be called" }) do
      post add_album_url, params: { album: { cover_image: "" } }
    end
    assert_response :unprocessable_content
  end

  test "rejects non-image uploads" do
    file = fixture_file_upload("cover.png", "application/pdf")
    with_recognizer(->(_) { flunk "recognizer should not be called" }) do
      post add_album_url, params: { album: { cover_image: file } }
    end
    assert_response :unprocessable_content
  end

  private
    def with_recognizer(fake)
      original = AlbumCoverRecognizer.method(:call)
      AlbumCoverRecognizer.define_singleton_method(:call, &fake)
      yield
    ensure
      AlbumCoverRecognizer.define_singleton_method(:call, original)
    end
end
