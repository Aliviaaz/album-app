require "rails_helper"

RSpec.describe "/artists", type: :request do
  let!(:artist) { create(:artist) }
  let(:valid_attributes) { attributes_for(:artist) }

  describe "GET /index" do
    it "renders a successful response" do
      get artists_url
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_artist_url
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    it "creates a new Artist and redirects to it" do
      expect {
        post artists_url, params: { artist: valid_attributes }
      }.to change(Artist, :count).by(1)

      expect(response).to redirect_to(artist_url(Artist.last))
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      get artist_url(artist)
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      get edit_artist_url(artist)
      expect(response).to be_successful
    end
  end

  describe "PATCH /update" do
    it "redirects to the artist" do
      patch artist_url(artist), params: { artist: valid_attributes }
      expect(response).to redirect_to(artist_url(artist))
    end
  end

  describe "DELETE /destroy" do
    it "destroys the artist and redirects to the list" do
      expect {
        delete artist_url(artist)
      }.to change(Artist, :count).by(-1)

      expect(response).to redirect_to(artists_url)
    end
  end
end
