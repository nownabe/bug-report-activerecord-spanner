# frozen_string_literal: true

require "active_record"
require "active_record/tasks/spanner_database_tasks"
require "minitest/autorun"
require "logger"

require_relative "./spanner_admin"

ENV["SPANNER_EMULATOR_HOST"] = "localhost:9010"

config = {
  adapter: "spanner",
  project: "my-project",
  instance: "my-instance",
  database: "test"
}
db_config = ActiveRecord::DatabaseConfigurations::HashConfig.new("test", "primary", config)


ActiveRecord::Base.establish_connection(config)
ActiveRecord::Base.logger = Logger.new(STDOUT)
ActiveRecord::Tasks::DatabaseTasks.db_dir = File.expand_path("./db", __dir__)


# (0) Prepare a clean database for testing

SpannerAdmin.new(config).ensure_instance

# activerecord-spanner-adapter v1.1.1 has a bug for purge.
# It has already been fixed on main branch.
# ActiveRecord::Tasks::DatabaseTasks.purge(config)

begin
  ActiveRecord::Tasks::DatabaseTasks.drop(config)
rescue NoMethodError
ensure
  ActiveRecord::Tasks::DatabaseTasks.create(config)
end


# (1) Create tables

ActiveRecord::Schema.define do
  create_table :posts, force: true do |t|
  end
end


# (2) Dump schema

ActiveRecord::Tasks::DatabaseTasks.dump_schema(db_config, :ruby)


# (3) Recreate database

ActiveRecord::Tasks::DatabaseTasks.drop(config)
ActiveRecord::Tasks::DatabaseTasks.create(config)


# (4) Load schema

$db_config = db_config

class SchemaLoadTest < Minitest::Test
  def test_load_schema
    ActiveRecord::Tasks::DatabaseTasks.load_schema($db_config, :ruby)
  end
end
