# Other examples

## travel_to

Code:

```ruby
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
```

Output:

```sh
❯ BACKTRACE=1 rails test      
Run options: --seed 5443

# Running:

..E

Error:
PostTest#test_travel_to_the_past:
ActiveRecord::StatementInvalid: Google::Cloud::DeadlineExceededError: 4:4:Deadline Exceeded. debug_error_string:{UNKNOWN:Deadline Exceeded {created_time:"2022-11-30T14:56:13.047528256+09:00", grpc_status:4}}
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/google-cloud-spanner-v1-0.13.0/lib/google/cloud/spanner/v1/spanner/client.rb:1512:in `rescue in begin_transaction'
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/google-cloud-spanner-v1-0.13.0/lib/google/cloud/spanner/v1/spanner/client.rb:1474:in `begin_transaction'
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/google-cloud-spanner-2.16.1/lib/google/cloud/spanner/service.rb:461:in `begin_transaction'
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/google-cloud-spanner-2.16.1/lib/google/cloud/spanner/session.rb:1170:in `create_transaction'
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/activerecord-spanner-adapter-1.2.2/lib/activerecord_spanner_adapter/transaction.rb:81:in `force_begin_read_write'
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/activerecord-spanner-adapter-1.2.2/lib/activerecord_spanner_adapter/transaction.rb:93:in `commit'
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/activerecord-spanner-adapter-1.2.2/lib/activerecord_spanner_adapter/connection.rb:271:in `commit_transaction'
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/activerecord-spanner-adapter-1.2.2/lib/active_record/connection_adapters/spanner/database_statements.rb:195:in `block in commit_db_transaction'
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/activesupport-7.0.4/lib/active_support/concurrency/load_interlock_aware_monitor.rb:25:in `handle_interrupt'
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/activesupport-7.0.4/lib/active_support/concurrency/load_interlock_aware_monitor.rb:25:in `block in synchronize'
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/activesupport-7.0.4/lib/active_support/concurrency/load_interlock_aware_monitor.rb:21:in `handle_interrupt'
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/activesupport-7.0.4/lib/active_support/concurrency/load_interlock_aware_monitor.rb:21:in `synchronize'
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/activerecord-7.0.4/lib/active_record/connection_adapters/abstract_adapter.rb:765:in `block in log'
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/activesupport-7.0.4/lib/active_support/notifications/instrumenter.rb:24:in `instrument'
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/activerecord-7.0.4/lib/active_record/connection_adapters/abstract_adapter.rb:756:in `log'
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/activerecord-spanner-adapter-1.2.2/lib/active_record/connection_adapters/spanner/database_statements.rb:194:in `commit_db_transaction'
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/activerecord-7.0.4/lib/active_record/connection_adapters/abstract/transaction.rb:219:in `commit'
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/activerecord-7.0.4/lib/active_record/connection_adapters/abstract/transaction.rb:303:in `block in commit_transaction'
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/activesupport-7.0.4/lib/active_support/concurrency/load_interlock_aware_monitor.rb:25:in `handle_interrupt'
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/activesupport-7.0.4/lib/active_support/concurrency/load_interlock_aware_monitor.rb:25:in `block in synchronize'
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/activesupport-7.0.4/lib/active_support/concurrency/load_interlock_aware_monitor.rb:21:in `handle_interrupt'
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/activesupport-7.0.4/lib/active_support/concurrency/load_interlock_aware_monitor.rb:21:in `synchronize'
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/activerecord-7.0.4/lib/active_record/connection_adapters/abstract/transaction.rb:294:in `commit_transaction'
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/activerecord-7.0.4/lib/active_record/connection_adapters/abstract/transaction.rb:345:in `ensure in block in within_new_transaction'
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/activerecord-7.0.4/lib/active_record/connection_adapters/abstract/transaction.rb:344:in `block in within_new_transaction'
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/activesupport-7.0.4/lib/active_support/concurrency/load_interlock_aware_monitor.rb:25:in `handle_interrupt'
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/activesupport-7.0.4/lib/active_support/concurrency/load_interlock_aware_monitor.rb:25:in `block in synchronize'
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/activesupport-7.0.4/lib/active_support/concurrency/load_interlock_aware_monitor.rb:21:in `handle_interrupt'
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/activesupport-7.0.4/lib/active_support/concurrency/load_interlock_aware_monitor.rb:21:in `synchronize'
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/activerecord-7.0.4/lib/active_record/connection_adapters/abstract/transaction.rb:317:in `within_new_transaction'
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/activerecord-7.0.4/lib/active_record/connection_adapters/abstract/database_statements.rb:316:in `transaction'
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/activerecord-spanner-adapter-1.2.2/lib/active_record/connection_adapters/spanner/database_statements.rb:129:in `transaction'
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/activerecord-7.0.4/lib/active_record/transactions.rb:209:in `transaction'
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/activerecord-spanner-adapter-1.2.2/lib/activerecord_spanner_adapter/base.rb:24:in `create!'
    /home/nownabe/src/github.com/nownabe/bug-report-activerecord-spanner/example_app/test/models/post_test.rb:10:in `block (2 levels) in <class:PostTest>'
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/activesupport-7.0.4/lib/active_support/testing/time_helpers.rb:173:in `travel_to'
    /home/nownabe/src/github.com/nownabe/bug-report-activerecord-spanner/example_app/test/models/post_test.rb:9:in `block in <class:PostTest>'


rails test test/models/post_test.rb:8



Finished in 0.078963s, 37.9923 runs/s, 0.0000 assertions/s.
3 runs, 0 assertions, 0 failures, 1 errors, 0 skips

```
