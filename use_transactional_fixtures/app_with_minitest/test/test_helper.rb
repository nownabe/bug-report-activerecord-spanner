ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveRecord::ConnectionAdapters::DatabaseStatements
  def insert_fixtures_set(fixture_set, tables_to_delete = [])
    fixture_inserts = build_fixture_statements(fixture_set)
    table_deletes = build_truncate_statements(tables_to_delete)
    statements = table_deletes + fixture_inserts

    with_multi_statements do
      disable_referential_integrity do
        transaction(requires_new: true) do
          execute_batch(statements, "Fixtures Load")
        end
      end
    end
  end
end

module ActiveRecord::ConnectionAdapters::Spanner::DatabaseStatements
  def build_truncate_statement(table_name)
    "DELETE FROM #{quote_table_name(table_name)} WHERE TRUE"
  end

  def build_fixture_statements(*args)
    super.flatten.compact
  end
end

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end
