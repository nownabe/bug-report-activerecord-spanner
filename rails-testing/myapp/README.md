# Reproduction

## New Rails App 

Enable spanner emulator.

```sh
export SPANNER_EMULATOR_HOST=localhost:9010
rails _7.0.4_ new myapp --skip-bundle
cd myapp
rm -rf .git
vi Gemfile
bundle install
vi config/database.yml
vi lib/tasks/spanner.rake
rails spanner:instance:create
rails g model Post text:string
vi test/models/post_test.rb
rails test
```

## Result

test code:

```ruby
require "test_helper"

class PostTest < ActiveSupport::TestCase
  test "the truth" do
    assert true
  end
end
```

Output:

```sh
❯ rails test
Running 1 tests in a single process (parallelization threshold is 50)
Run options: --seed 4874

# Running:

E

Error:
PostTest#test_the_truth:
ActiveRecord::StatementInvalid: Google::Cloud::InvalidArgumentError: 3:DELETE must have a WHERE clause [at 1:1]
DELETE FROM `posts`
^. debug_error_string:{UNKNOWN:Error received from peer ipv6:%5B::1%5D:9010 {created_time:"2022-11-30T13:34:50.358839937+09:00", grpc_status:3, grpc_message:"DELETE must have a WHERE clause [at 1:1]\nDELETE FROM `posts`\n^"}}
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/google-cloud-spanner-2.16.1/lib/google/cloud/spanner/results.rb:314:in `rescue in from_enum'
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/google-cloud-spanner-2.16.1/lib/google/cloud/spanner/results.rb:305:in `from_enum'
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/google-cloud-spanner-2.16.1/lib/google/cloud/spanner/results.rb:332:in `execute_query'
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/google-cloud-spanner-2.16.1/lib/google/cloud/spanner/session.rb:348:in `execute_query'
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/activerecord-spanner-adapter-1.2.2/lib/activerecord_spanner_adapter/connection.rb:216:in `execute_sql_request'
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/activerecord-spanner-adapter-1.2.2/lib/activerecord_spanner_adapter/connection.rb:212:in `execute_query'
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/activerecord-spanner-adapter-1.2.2/lib/active_record/connection_adapters/spanner/database_statements.rb:43:in `block (3 levels) in execute'
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/activerecord-7.0.4/lib/active_record/connection_adapters/abstract/database_statements.rb:314:in `transaction'
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/activerecord-spanner-adapter-1.2.2/lib/active_record/connection_adapters/spanner/database_statements.rb:124:in `transaction'
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/activerecord-spanner-adapter-1.2.2/lib/active_record/connection_adapters/spanner/database_statements.rb:42:in `block (2 levels) in execute'
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/activesupport-7.0.4/lib/active_support/concurrency/share_lock.rb:187:in `yield_shares'
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/activesupport-7.0.4/lib/active_support/dependencies/interlock.rb:41:in `permit_concurrent_loads'
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/activerecord-spanner-adapter-1.2.2/lib/active_record/connection_adapters/spanner/database_statements.rb:40:in `block in execute'
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/activesupport-7.0.4/lib/active_support/concurrency/load_interlock_aware_monitor.rb:25:in `handle_interrupt'
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/activesupport-7.0.4/lib/active_support/concurrency/load_interlock_aware_monitor.rb:25:in `block in synchronize'
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/activesupport-7.0.4/lib/active_support/concurrency/load_interlock_aware_monitor.rb:21:in `handle_interrupt'
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/activesupport-7.0.4/lib/active_support/concurrency/load_interlock_aware_monitor.rb:21:in `synchronize'
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/activerecord-7.0.4/lib/active_record/connection_adapters/abstract_adapter.rb:765:in `block in log'
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/activesupport-7.0.4/lib/active_support/notifications/instrumenter.rb:24:in `instrument'
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/activerecord-7.0.4/lib/active_record/connection_adapters/abstract_adapter.rb:756:in `log'
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/activerecord-spanner-adapter-1.2.2/lib/active_record/connection_adapters/spanner/database_statements.rb:38:in `execute'
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/activerecord-7.0.4/lib/active_record/connection_adapters/abstract/database_statements.rb:460:in `block in execute_batch'
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/activerecord-7.0.4/lib/active_record/connection_adapters/abstract/database_statements.rb:459:in `each'
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/activerecord-7.0.4/lib/active_record/connection_adapters/abstract/database_statements.rb:459:in `execute_batch'
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/activerecord-7.0.4/lib/active_record/connection_adapters/abstract/database_statements.rb:409:in `block (3 levels) in insert_fixtures_set'
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/activerecord-7.0.4/lib/active_record/connection_adapters/abstract/transaction.rb:319:in `block in within_new_transaction'
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/activesupport-7.0.4/lib/active_support/concurrency/load_interlock_aware_monitor.rb:25:in `handle_interrupt'
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/activesupport-7.0.4/lib/active_support/concurrency/load_interlock_aware_monitor.rb:25:in `block in synchronize'
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/activesupport-7.0.4/lib/active_support/concurrency/load_interlock_aware_monitor.rb:21:in `handle_interrupt'
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/activesupport-7.0.4/lib/active_support/concurrency/load_interlock_aware_monitor.rb:21:in `synchronize'
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/activerecord-7.0.4/lib/active_record/connection_adapters/abstract/transaction.rb:317:in `within_new_transaction'
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/activerecord-7.0.4/lib/active_record/connection_adapters/abstract/database_statements.rb:316:in `transaction'
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/activerecord-spanner-adapter-1.2.2/lib/active_record/connection_adapters/spanner/database_statements.rb:129:in `transaction'
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/activerecord-7.0.4/lib/active_record/connection_adapters/abstract/database_statements.rb:408:in `block (2 levels) in insert_fixtures_set'
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/activerecord-7.0.4/lib/active_record/connection_adapters/abstract_adapter.rb:510:in `disable_referential_integrity'
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/activerecord-7.0.4/lib/active_record/connection_adapters/abstract/database_statements.rb:407:in `block in insert_fixtures_set'
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/activerecord-7.0.4/lib/active_record/connection_adapters/abstract/database_statements.rb:531:in `with_multi_statements'
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/activerecord-7.0.4/lib/active_record/connection_adapters/abstract/database_statements.rb:406:in `insert_fixtures_set'
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/activerecord-7.0.4/lib/active_record/fixtures.rb:630:in `block in insert'
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/activerecord-7.0.4/lib/active_record/fixtures.rb:621:in `each'
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/activerecord-7.0.4/lib/active_record/fixtures.rb:621:in `insert'
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/activerecord-7.0.4/lib/active_record/fixtures.rb:607:in `read_and_insert'
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/activerecord-7.0.4/lib/active_record/fixtures.rb:567:in `create_fixtures'
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/activerecord-7.0.4/lib/active_record/test_fixtures.rb:275:in `load_fixtures'
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/activerecord-7.0.4/lib/active_record/test_fixtures.rb:125:in `setup_fixtures'
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/activerecord-7.0.4/lib/active_record/test_fixtures.rb:10:in `before_setup'
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/activesupport-7.0.4/lib/active_support/testing/setup_and_teardown.rb:40:in `before_setup'


rails test test/models/post_test.rb:4



Finished in 0.062931s, 15.8905 runs/s, 0.0000 assertions/s.
1 runs, 0 assertions, 0 failures, 1 errors, 0 skips

```

## Workarounds

### 1. Disable fixtures

```ruby
# test/test_helper.rb

ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  # fixtures :all

  # Add more helper methods to be used by all tests here...
end
```

### 2. Patch ActiveRecord and Cloud Spanner

```ruby
# test/test_helper.rb

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
```
