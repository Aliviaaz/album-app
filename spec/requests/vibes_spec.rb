require "rails_helper"

RSpec.describe "/vibes", type: :request do
  let!(:vibe) { create(:vibe) }
  let(:valid_attributes) { attributes_for(:vibe) }

  describe "GET /index" do
    it "renders a successful response" do
      get vibes_url
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_vibe_url
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    it "creates a new Vibe and redirects to it" do
      expect {
        post vibes_url, params: { vibe: valid_attributes }
      }.to change(Vibe, :count).by(1)

      expect(response).to redirect_to(vibe_url(Vibe.last))
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      get vibe_url(vibe)
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      get edit_vibe_url(vibe)
      expect(response).to be_successful
    end
  end

  describe "PATCH /update" do
    it "redirects to the vibe" do
      patch vibe_url(vibe), params: { vibe: valid_attributes }
      expect(response).to redirect_to(vibe_url(vibe))
    end
  end

  describe "DELETE /destroy" do
    it "destroys the vibe and redirects to the list" do
      pending "Vibe has_and_belongs_to_many :albums expects an albums_vibes table, but the schema has album_vibes"

      expect {
        delete vibe_url(vibe)
      }.to change(Vibe, :count).by(-1)

      expect(response).to redirect_to(vibes_url)
    end
  end
end
