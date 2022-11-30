require "test_helper"


# https://github.com/googleapis/google-cloud-ruby/blob/main/google-cloud-spanner-v1/lib/google/cloud/spanner/v1/spanner/client.rb
Google::Cloud::Spanner::V1::Spanner::Client.configure do |c|
  timeout_sec = 10 * 365 * 24 * 60 * 60 # ten years

  c.rpcs.create_session.timeout = timeout_sec
  c.rpcs.batch_create_sessions.timeout = timeout_sec
  c.rpcs.get_session.timeout = timeout_sec
  c.rpcs.list_sessions.timeout = timeout_sec
  c.rpcs.delete_session.timeout = timeout_sec
  c.rpcs.execute_sql.timeout = timeout_sec
  c.rpcs.execute_streaming_sql.timeout = timeout_sec
  c.rpcs.read.timeout = timeout_sec
  c.rpcs.streaming_read.timeout = timeout_sec
  c.rpcs.begin_transaction.timeout = timeout_sec
  c.rpcs.commit.timeout = timeout_sec
  c.rpcs.rollback.timeout = timeout_sec
  c.rpcs.partition_query.timeout = timeout_sec
  c.rpcs.partition_read.timeout = timeout_sec
end

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
