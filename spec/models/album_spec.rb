require "rails_helper"

RSpec.describe Album, type: :model do
  it "requires an artist" do
    expect(build(:album, artist: nil)).not_to be_valid
  end

  it "has many songs" do
    album = create(:album)
    song = create(:song, album: album)

    expect(album.songs).to contain_exactly(song)
  end
end
