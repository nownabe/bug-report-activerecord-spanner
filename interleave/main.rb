# frozen_string_literal: true

require "bundler/inline"

gemfile(true) do
  source "https://rubygems.org"
  git_source(:github) { |repo| "https://github.com/#{repo}.git" }

  gem "google-cloud-spanner"

  gem "activerecord", "7.0.4"
  gem "activerecord-spanner-adapter", "1.2.2"
  gem "composite_primary_keys", "14.0.4"

  gem "debug"
end


require "debug"
require "active_record"
require "active_record/tasks/spanner_database_tasks"
require "activerecord-spanner-adapter"
require "composite_primary_keys"
require "minitest/autorun"
require "logger"

require_relative "./spanner_admin"

ENV["SPANNER_EMULATOR_HOST"] = "localhost:9010"

config = {
  adapter: "spanner",
  project: "my-project",
  instance: "my-instance",
  database: "test-interleave"
}
db_config = ActiveRecord::DatabaseConfigurations::HashConfig.new("test", "primary", config)


ActiveRecord::Base.establish_connection(config)
ActiveRecord::Base.logger = Logger.new(STDOUT)
ActiveRecord::Tasks::DatabaseTasks.db_dir = File.expand_path("./db", __dir__)


SpannerAdmin.new(config).ensure_instance

begin
  ActiveRecord::Tasks::DatabaseTasks.drop(config)
rescue NoMethodError
ensure
  ActiveRecord::Tasks::DatabaseTasks.create(config)
end

ActiveRecord::Schema.define do
  create_table :singers, id: false do |t|
    t.primary_key :singer_id
    t.string :name
    t.timestamps
  end

  create_table :albums, id: false do |t|
    t.interleave_in :singers
    t.parent_key :singer_id
    t.primary_key :album_id
    t.string :title
    t.timestamps
  end
end

class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
end

class Singer < ApplicationRecord
  has_many :albums, foreign_key: :singer_id
  has_many :tracks, foreign_key: :singer_id
end

class Album < ApplicationRecord
  self.primary_keys = [:singer_id, :album_id]

  belongs_to :singer, foreign_key: :singer_id
  has_many :tracks, foreign_key: [:singer_id, :album_id]
end

Album.partial_inserts = false

class InterleaveTest < Minitest::Test
  def test_interleave
    singer = Singer.create!(name: "Singer 1")
    Album.create!(singer: singer, title: "Album 1")
  end
end
