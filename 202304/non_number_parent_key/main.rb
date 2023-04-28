# frozen_string_literal: true

require "bundler/inline"

gemfile(true) do
  source "https://rubygems.org"
  git_source("github") { |repo| "https://github.com/#{repo}.git" }

  gem "google-cloud-spanner"

  gem "activerecord", "7.0.4.3"
  gem "activerecord-spanner-adapter", "1.4.1"
  gem "composite_primary_keys", "14.0.6"
end


require "active_record"
require "active_record/tasks/spanner_database_tasks"
require "minitest/autorun"
require "logger"
require "securerandom"

require_relative "../../spanner_admin"


ENV["SPANNER_EMULATOR_HOST"] = "localhost:9010"

config = {
  adapter: "spanner",
  project: "my-project",
  instance: "my-instance",
  database: "interleave",
}

ActiveRecord::Base.establish_connection(config)
ActiveRecord::Base.logger = Logger.new(STDOUT)
ActiveRecord::Tasks::DatabaseTasks.db_dir = File.expand_path("./db", __dir__)

SpannerAdmin.new(config).ensure_instance

ActiveRecord::Tasks::DatabaseTasks.drop(config)
ActiveRecord::Tasks::DatabaseTasks.create(config)


if ENV["PATCH"]
  module ActiveRecord
    class Base
      def self._set_composite_primary_key_value primary_key, values
        value = values[primary_key]
        type = ActiveModel::Type::BigInteger.new

        if value.is_a? ActiveModel::Attribute
          type = value.type
          value = value.value
        end

        return value unless prefetch_primary_key?

        if value.nil?
          value = next_sequence_value
        end

        values[primary_key] =
          if ActiveRecord::VERSION::MAJOR >= 7
            ActiveModel::Attribute.from_database primary_key, value, type
          else
            value
          end

        value
      end
    end
  end
end


ActiveRecord::Schema.define do
  create_table :singers, id: false do |t|
    t.string :singer_id, limit: 36, primary_key: true, null: false
    t.string :name, null: false
  end

  create_table :albums, id: false do |t|
    t.interleave_in :singers
    t.string :singer_id, limit: 36, parent_key: true, primary_key: true, null: false
    t.integer :album_id, primary_key: true, null: false
    t.string :title, null: false
  end
end


class Singer < ActiveRecord::Base
  has_many :albums, foreign_key: :singer_id
end

class Album < ActiveRecord::Base
  self.primary_keys = [:singer_id, :album_id]

  belongs_to :singer, foreign_key: :singer_id
end


class InterleaveTest < Minitest::Test
  def test_current_timestamp
    id = SecureRandom.uuid # Error with v1.3.1-v1.4.1
    # id = "001" # Error with v1.3.1-v1.4.1
    # id = "1"
    singer = Singer.create!(id: id, name: "a singer")
    Album.create!(singer: singer, title: "an album")
  end
end

