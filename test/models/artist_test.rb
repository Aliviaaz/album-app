require "test_helper"

class ArtistTest < ActiveSupport::TestCase
  test "loads the day6 fixture" do
    artist = artists(:day6)

    assert_equal "Day6", artist.name
    assert artist.is_group
  end

  test "loads a solo artist fixture" do
    artist = artists(:two)

    refute artist.is_group
  end

  test "albums can reference an artist fixture" do
    assert_equal artists(:day6), albums(:sunrise).artist
  end
end
