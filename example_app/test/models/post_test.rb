require "test_helper"

class PostTest < ActiveSupport::TestCase
  test "now" do
    Post.create!(text: "now")
  end

  test "travel_to the past" do
    travel_to Time.zone.local(2020, 1, 1) do
      Post.create!(text: "to the past")
    end
  end

  test "travel_to the future" do
    travel_to Time.zone.local(2024, 1, 1) do
      Post.create!(text: "to the future")
    end
  end
end
