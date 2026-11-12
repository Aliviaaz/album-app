require "rails_helper"

RSpec.describe Artist, type: :model do
  it "can be a group" do
    artist = create(:artist, :group, name: "Day6")

    expect(artist.name).to eq("Day6")
    expect(artist.is_group).to be(true)
  end

  it "is a solo artist by default" do
    expect(create(:artist).is_group).to be(false)
  end

  it "can be referenced by an album" do
    artist = create(:artist)
    album = create(:album, artist: artist)

    expect(album.artist).to eq(artist)
  end
end
