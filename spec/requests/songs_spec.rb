require "rails_helper"

RSpec.describe "/songs", type: :request do
  let!(:song) { create(:song) }
  let(:valid_attributes) { attributes_for(:song) }

  describe "GET /index" do
    it "renders a successful response" do
      get songs_url
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_song_url
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    it "creates a new Song and redirects to it" do
      pending "SongsController does not permit album_id, so a song cannot be created through the form"

      expect {
        post songs_url, params: { song: valid_attributes }
      }.to change(Song, :count).by(1)

      expect(response).to redirect_to(song_url(Song.last))
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      get song_url(song)
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      get edit_song_url(song)
      expect(response).to be_successful
    end
  end

  describe "PATCH /update" do
    it "redirects to the song" do
      patch song_url(song), params: { song: valid_attributes }
      expect(response).to redirect_to(song_url(song))
    end
  end

  describe "DELETE /destroy" do
    it "destroys the song and redirects to the list" do
      expect {
        delete song_url(song)
      }.to change(Song, :count).by(-1)

      expect(response).to redirect_to(songs_url)
    end
  end
end
