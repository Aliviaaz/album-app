require "rails_helper"

RSpec.describe Song, type: :model do
  it "requires an album" do
    expect(build(:song, album: nil)).not_to be_valid
  end

  it "has many vibes through song vibes" do
    song = create(:song)
    vibe = create(:vibe)
    create(:song_vibe, song: song, vibe: vibe)

    expect(song.vibes).to contain_exactly(vibe)
  end
end
