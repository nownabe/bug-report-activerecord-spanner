# frozen_string_literal: true

require "bundler/inline"

gemfile(true) do
  source "https://rubygems.org"
  git_source("github") { |repo| "https://github.com/#{repo}.git" }

  gem "google-cloud-spanner"
  gem "sqlite3"

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
  adapter: "sqlite3",
  database: ":memory:",
}
ActiveRecord::Base.establish_connection(config)
ActiveRecord::Base.logger = Logger.new(STDOUT)
ActiveRecord::Tasks::DatabaseTasks.db_dir = File.expand_path("./db", __dir__)


if ENV["PATCH"]
  module ActiveRecord
    module ModelSchema
      module ClassMethods
        def load_schema!
          unless table_name
            raise ActiveRecord::TableNotSpecified, "#{self} has no table configured. Set one with #{self}.table_name="
          end

          columns_hash = connection.schema_cache.columns_hash(table_name)
          columns_hash = columns_hash.except(*ignored_columns) unless ignored_columns.empty?
          @columns_hash = columns_hash.freeze
          @columns_hash.each do |name, column|
            type = connection.lookup_cast_type_from_column(column)
            type = _convert_type_from_options(type)
            define_attribute(
              name,
              type,
              default: column.default,
              user_provided_default: false
            )
          end
        end
      end
    end
    module Attributes
      module ClassMethods
        def define_default_attribute(name, value, type, from_user:)
          if value == NO_DEFAULT_PROVIDED
            default_attribute = _default_attributes[name].with_type(type)
          elsif from_user
            default_attribute = ActiveModel::Attribute::UserProvidedDefault.new(
              name,
              value,
              type,
              _default_attributes.fetch(name.to_s) { nil },
            )
          else
            default_attribute = ActiveModel::Attribute.from_database(name, value, type)
          end
          _default_attributes[name] = default_attribute
        end
      end
    end

    module Transactions
      def restore_transaction_record_state(force_restore_state = false)
        if restore_state = @_start_transaction_state
          if force_restore_state || restore_state[:level] <= 1
            @new_record = restore_state[:new_record]
            @previously_new_record = restore_state[:previously_new_record]
            @destroyed  = restore_state[:destroyed]
            @attributes = restore_state[:attributes].map do |attr|
              value = @attributes.fetch_value(attr.name)
              attr = attr.with_value_from_user(value) if attr.value != value
              attr
            end
            @mutations_from_database = nil
            @mutations_before_last_save = nil
            if @attributes.fetch_value(@primary_key) != restore_state[:id]
              @attributes.write_from_user(@primary_key, restore_state[:id])
            end
            freeze if restore_state[:frozen?]
          end
        end
      end
    end
  end

  module ActiveRecord
    module ConnectionAdapters
      class Column
        def has_default?
          d = super && !virtual?
          puts("⭐ #{self} has default? #{d}")
          d
        end
      end
    end
  end
end


ActiveRecord::Schema.define do
  create_table :items do |t|
    t.string :name
    t.datetime :timestamp, null: false, default: -> { "CURRENT_TIMESTAMP" }
  end
end


class Item < ActiveRecord::Base
end


class DefaultValueTest < Minitest::Test
  def test_current_timestamp
    # binding.irb
    item = Item.new(name: "hoge")
    item.save!
    item.reload
    pp item
  end
end
