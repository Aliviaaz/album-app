require "test_helper"

class AlbumTracklistFetcherTest < ActiveSupport::TestCase
  # Stands in for RubyLLM::Chat: records the prompt and returns a canned response.
  class FakeChat
    attr_reader :prompt

    def initialize(parsed) = @parsed = parsed
    def with_instructions(*) = self
    def with_schema(*) = self
    def with_thinking(**) = self

    def ask(prompt, **)
      @prompt = prompt
      Struct.new(:parsed).new(@parsed)
    end
  end

  setup do
    @album = albums(:sunrise)
  end

  test "returns cleaned song names and sends artist and title" do
    chat = FakeChat.new({ "identified" => true, "songs" => [ " Letting Go ", "", "Congratulations" ] })
    songs = with_chat(chat) { AlbumTracklistFetcher.call(@album) }

    assert_equal [ "Letting Go", "Congratulations" ], songs
    assert_includes chat.prompt, "Artist: Day6"
    assert_includes chat.prompt, "Album: Sunrise"
  end

  test "raises when the model doesn't know the album" do
    chat = FakeChat.new({ "identified" => false, "songs" => [] })
    assert_raises(AlbumTracklistFetcher::LookupError) do
      with_chat(chat) { AlbumTracklistFetcher.call(@album) }
    end
  end

  test "raises without calling the model when the album has no artist" do
    album = Album.new(title: "Untitled")
    with_chat(->(**) { flunk "model should not be called" }) do
      assert_raises(AlbumTracklistFetcher::LookupError) { AlbumTracklistFetcher.call(album) }
    end
  end

  private
    def with_chat(chat)
      original = RubyLLM.method(:chat)
      fake = chat.respond_to?(:call) ? chat : ->(**) { chat }
      RubyLLM.define_singleton_method(:chat, &fake)
      yield
    ensure
      RubyLLM.define_singleton_method(:chat, original)
    end
end
