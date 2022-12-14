# Interleave issue

When `partial_inserts` is `false`, saving a record to the interleaved child table fails.
Rails 7 introduces `partial_inserts` and its default value is `false`.

References

* [Configuring Rails Applications — Ruby on Rails Guides](https://edgeguides.rubyonrails.org/configuring.html#config-active-record-partial-inserts)
* [Rails 7 introduces partial_inserts config for ActiveRecord](https://blog.kiprosh.com/rails-7-introduces-partial-inserts-config-for-activerecord/)
* [rails/dirty.rb at v7.0.4 · rails/rails](https://github.com/rails/rails/blob/v7.0.4/activerecord/lib/active_record/attribute_methods/dirty.rb#L221)
* [rails/dirty.rb at v7.0.4 · rails/rails](https://github.com/rails/rails/blob/v7.0.4/activerecord/lib/active_record/attribute_methods/dirty.rb#L231)

```
Fetching gem metadata from https://rubygems.org/.........
Resolving dependencies...
Using concurrent-ruby 1.1.10
Using ruby2_keywords 0.0.5
Using google-protobuf 3.21.11 (x86_64-linux)
Using memoist 0.16.2
Using minitest 5.16.3
Using faraday-net_http 3.0.2
Using google-cloud-errors 1.3.0
Using jwt 2.5.0
Using multi_json 1.15.0
Using bundler 2.3.21
Using os 1.1.4
Using io-console 0.5.11
Using public_suffix 5.0.1
Using googleapis-common-protos-types 1.4.0
Using faraday 2.7.1
Using i18n 1.12.0
Using tzinfo 2.0.5
Using grpc 1.50.0 (x86_64-linux)
Using reline 0.3.2
Using irb 1.6.1
Using activesupport 7.0.4
Using google-cloud-env 1.6.0
Using faraday-retry 2.0.0
Using debug 1.7.0
Using activemodel 7.0.4
Using addressable 2.8.1
Using google-cloud-core 1.6.0
Using signet 0.17.0
Using googleapis-common-protos 1.4.0
Using googleauth 1.3.0
Using grpc-google-iam-v1 1.2.0
Using activerecord 7.0.4
Using gapic-common 0.16.0
Using composite_primary_keys 14.0.4
Using google-cloud-spanner-admin-database-v1 0.11.0
Using google-cloud-spanner-admin-instance-v1 0.8.0
Using google-cloud-spanner-v1 0.13.0
Using google-cloud-spanner 2.16.1
Using activerecord-spanner-adapter 1.2.2
Dropped database 'test-interleave'
Created database 'test-interleave'
-- create_table(:singers, {:id=>false})
   -> 0.0043s
-- create_table(:albums, {:id=>false})
   -> 0.0008s
D, [2022-12-14T16:11:01.292833 #725060] DEBUG -- :   [1m[36mActiveRecord::InternalMetadata Load (21.1ms)[0m  [1m[34mSELECT `ar_internal_metadata`.* FROM `ar_internal_metadata` WHERE `ar_internal_metadata`.`key` = @p1 LIMIT @p2[0m
D, [2022-12-14T16:11:01.329283 #725060] DEBUG -- :   [1m[35mSQL (0.1ms)[0m  [1m[35mBEGIN[0m
D, [2022-12-14T16:11:01.333455 #725060] DEBUG -- :   [1m[36mActiveRecord::InternalMetadata Create (2.9ms)[0m  [1m[32mINSERT INTO `ar_internal_metadata` (`key`, `value`, `created_at`, `updated_at`) VALUES (@p1, @p2, @p3, @p4)[0m
D, [2022-12-14T16:11:01.335951 #725060] DEBUG -- :   [1m[35mSQL (1.9ms)[0m  [1m[35mCOMMIT[0m
Run options: --seed 29699

# Running:

D, [2022-12-14T16:11:01.348092 #725060] DEBUG -- :   [1m[35mSQL (0.0ms)[0m  [1m[35mBEGIN buffered_mutations[0m
D, [2022-12-14T16:11:01.411524 #725060] DEBUG -- :   [1m[35mSQL (4.2ms)[0m  [1m[35mCOMMIT[0m
D, [2022-12-14T16:11:01.411941 #725060] DEBUG -- :   [1m[35mSQL (0.1ms)[0m  [1m[35mBEGIN buffered_mutations[0m
D, [2022-12-14T16:11:01.450459 #725060] DEBUG -- :   [1m[35mSQL (3.7ms)[0m  [1m[35mCOMMIT[0m
D, [2022-12-14T16:11:01.450673 #725060] DEBUG -- :   [1m[35mSQL (0.0ms)[0m  [1m[31mROLLBACK[0m
E

Finished in 0.105278s, 9.4987 runs/s, 0.0000 assertions/s.

  1) Error:
InterleaveTest#test_interleave:
ActiveRecord::StatementInvalid: Google::Cloud::FailedPreconditionError: 9:Cannot specify a null value for column: albums.album_id in table: albums. debug_error_string:{UNKNOWN:Error received from peer ipv6:%5B::1%5D:9010 {grpc_message:"Cannot specify a null value for column: albums.album_id in table: albums", grpc_status:9, created_time:"2022-12-14T16:11:01.449528842+09:00"}}
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/google-cloud-spanner-v1-0.13.0/lib/google/cloud/spanner/v1/spanner/client.rb:1632:in `rescue in commit'
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/google-cloud-spanner-v1-0.13.0/lib/google/cloud/spanner/v1/spanner/client.rb:1594:in `commit'
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/google-cloud-spanner-2.16.1/lib/google/cloud/spanner/service.rb:439:in `commit'
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/activerecord-spanner-adapter-1.2.2/lib/spanner_client_ext.rb:29:in `commit_transaction'
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/activerecord-spanner-adapter-1.2.2/lib/activerecord_spanner_adapter/transaction.rb:95:in `commit'
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
    main.rb:91:in `test_interleave'

1 runs, 0 assertions, 0 failures, 1 errors, 0 skips
```
