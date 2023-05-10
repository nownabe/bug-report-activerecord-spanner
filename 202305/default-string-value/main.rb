# frozen_string_literal: true

require "bundler/inline"

gemfile(true) do
  source "https://rubygems.org"
  git_source("github") { |repo| "https://github.com/#{repo}.git" }

  gem "google-cloud-spanner"

  gem "activerecord", "7.0.4.3"
  gem "activerecord-spanner-adapter", "1.4.1"
end

require "active_record"
require "active_record/tasks/spanner_database_tasks"
require "minitest/autorun"
require "logger"

require_relative "../../spanner_admin"

ENV["SPANNER_EMULATOR_HOST"] = "localhost:9010"

config = {
  adapter: "spanner",
  project: "my-project",
  instance: "my-instance",
  database: "default-value",
}

ActiveRecord::Base.establish_connection(config)
ActiveRecord::Base.logger = Logger.new(STDOUT)
ActiveRecord::Tasks::DatabaseTasks.db_dir = File.expand_path("./db", __dir__)

SpannerAdmin.new(config).ensure_instance

ActiveRecord::Tasks::DatabaseTasks.drop(config)
ActiveRecord::Tasks::DatabaseTasks.create(config)

ActiveRecord::Schema.define do
  create_table :items do |t|
    t.string :name, default: "default_value"
  end
end

class Item < ActiveRecord::Base; end

class DefaultValueTest < Minitest::Test
  def test_string_default_value
    item = Item.create!
    assert_equal(item.name, item.reload.name)
  end
end
