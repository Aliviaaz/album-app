require "rails_helper"

RSpec.describe Vibe, type: :model do
  it "has many songs through song vibes" do
    vibe = create(:vibe)
    song = create(:song)
    create(:song_vibe, song: song, vibe: vibe)

    expect(vibe.songs).to contain_exactly(song)
  end
end
