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
db_config = ActiveRecord::DatabaseConfigurations::HashConfig.new("test", "primary", config)

ActiveRecord::Base.establish_connection(config)
ActiveRecord::Base.logger = Logger.new(STDOUT)
ActiveRecord::Tasks::DatabaseTasks.db_dir = File.expand_path("./db", __dir__)

SpannerAdmin.new(config).ensure_instance

ActiveRecord::Tasks::DatabaseTasks.drop(config)
ActiveRecord::Tasks::DatabaseTasks.create(config)




if ENV["PATCH"]
  require "activerecord_spanner_adapter/information_schema"

  module ActiveRecordSpannerAdapter
    class InformationSchema
      def table_columns(table_name, column_name: nil)
        sql = +"SELECT COLUMN_NAME, SPANNER_TYPE, IS_NULLABLE, GENERATION_EXPRESSION,"
        sql << " CAST(COLUMN_DEFAULT AS STRING) AS COLUMN_DEFAULT, ORDINAL_POSITION"
        sql << " FROM INFORMATION_SCHEMA.COLUMNS"
        sql << " WHERE TABLE_NAME=%<table_name>s"
        sql << " AND COLUMN_NAME=%<column_name>s" if column_name
        sql << " ORDER BY ORDINAL_POSITION ASC"

        column_options = column_options table_name, column_name
        execute_query(
          sql,
          table_name: table_name,
          column_name: column_name
        ).map do |row|
          type, limit = parse_type_and_limit row["SPANNER_TYPE"]
          column_name = row["COLUMN_NAME"]
          options = column_options[column_name]

          Table::Column.new \
            table_name,
            column_name,
            type,
            limit: limit,
            allow_commit_timestamp: options["allow_commit_timestamp"],
            ordinal_position: row["ORDINAL_POSITION"],
            nullable: row["IS_NULLABLE"] == "YES",
            default: extract_default(row),
            default_function: extract_default_function(row),
            generated: row["GENERATION_EXPRESSION"].present?
        end
      end

      private

      def column_default_function?(row)
        /\w+\(.*\)/.match?(row["COLUMN_DEFAULT"])
      end

      def extract_default(row)
        if column_default_function?(row)
          nil
        else
          row["COLUMN_DEFAULT"]
        end
      end

      def extract_default_function(row)
        return row["GENERATION_EXPRESSION"] if row["GENERATION_EXPRESSION"]
        return row["COLUMN_DEFAULT"] if column_default_function?(row)

        nil
      end
    end
  end
end


ActiveRecord::Schema.define do
  create_table :items do |t|
    t.string :name
    t.datetime :timestamp, null: false, default: -> { "CURRENT_TIMESTAMP()" }
  end
end


class Item < ActiveRecord::Base
end


class DefaultValueTest < Minitest::Test
  def test_current_timestamp
    item = Item.new(name: "hoge")
    item.save!
  end
end
