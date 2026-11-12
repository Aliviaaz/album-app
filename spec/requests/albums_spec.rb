require "rails_helper"

RSpec.describe "/albums", type: :request do
  let!(:album) { create(:album) }
  let(:valid_attributes) { attributes_for(:album) }

  describe "GET /index" do
    it "renders a successful response" do
      get albums_url
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_album_url
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    it "creates a new Album and redirects to it" do
      pending "AlbumsController does not permit artist_id, so an album cannot be created through the form"

      expect {
        post albums_url, params: { album: valid_attributes }
      }.to change(Album, :count).by(1)

      expect(response).to redirect_to(album_url(Album.last))
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      get album_url(album)
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      get edit_album_url(album)
      expect(response).to be_successful
    end
  end

  describe "PATCH /update" do
    it "redirects to the album" do
      patch album_url(album), params: { album: valid_attributes }
      expect(response).to redirect_to(album_url(album))
    end
  end

  describe "DELETE /destroy" do
    it "destroys the album and redirects to the list" do
      pending "There's a bad join table that needs to be renamed"

      expect {
        delete album_url(album)
      }.to change(Album, :count).by(-1)

      expect(response).to redirect_to(albums_url)
    end
  end
end
