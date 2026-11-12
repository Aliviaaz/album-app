require "rails_helper"

RSpec.describe SongVibe, type: :model do
  it "requires a song and a vibe" do
    expect(build(:song_vibe, song: nil)).not_to be_valid
    expect(build(:song_vibe, vibe: nil)).not_to be_valid
  end
end
