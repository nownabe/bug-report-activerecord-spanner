# Reproduction

Run:

```sh
ruby main.rb
```

Output:

```sh
$ ruby main.rb
Fetching gem metadata from https://rubygems.org/.........
Resolving dependencies...
Using concurrent-ruby 1.1.10
Using minitest 5.16.3
Using faraday-net_http 3.0.2
Using ruby2_keywords 0.0.5
Using google-cloud-errors 1.3.0
Using jwt 2.5.0
Using google-protobuf 3.21.10 (x86_64-linux)
Using memoist 0.16.2
Using multi_json 1.15.0
Using public_suffix 5.0.0
Using os 1.1.4
Using bundler 2.3.7
Using i18n 1.12.0
Using tzinfo 2.0.5
Using googleapis-common-protos-types 1.4.0
Using addressable 2.8.1
Using activesupport 7.0.4
Using grpc 1.50.0 (x86_64-linux)
Using googleapis-common-protos 1.3.12
Using faraday 2.7.1
Using activemodel 7.0.4
Using google-cloud-env 1.6.0
Using faraday-retry 2.0.0
Using signet 0.17.0
Using grpc-google-iam-v1 1.2.0
Using activerecord 7.0.4
Using googleauth 1.3.0
Using google-cloud-core 1.6.0
Using gapic-common 0.15.1
Using google-cloud-spanner-admin-database-v1 0.11.0
Using google-cloud-spanner-admin-instance-v1 0.8.0
Using google-cloud-spanner-v1 0.13.0
Using google-cloud-spanner 2.16.1
Using activerecord-spanner-adapter 1.2.2
Dropped database 'test'
Created database 'test'
-- create_table(:posts, {:force=>true})
   -> 0.0378s
D, [2022-12-01T11:13:14.414925 #794760] DEBUG -- :   [1m[36mActiveRecord::InternalMetadata Load (18.7ms)[0m  [1m[34mSELECT `ar_internal_metadata`.* FROM `ar_internal_metadata` WHERE `ar_internal_metadata`.`key` = @p1 LIMIT @p2[0m
D, [2022-12-01T11:13:14.453867 #794760] DEBUG -- :   [1m[35mSQL (0.1ms)[0m  [1m[35mBEGIN[0m
D, [2022-12-01T11:13:14.458536 #794760] DEBUG -- :   [1m[36mActiveRecord::InternalMetadata Create (3.0ms)[0m  [1m[32mINSERT INTO `ar_internal_metadata` (`key`, `value`, `created_at`, `updated_at`) VALUES (@p1, @p2, @p3, @p4)[0m
D, [2022-12-01T11:13:14.461519 #794760] DEBUG -- :   [1m[35mSQL (2.3ms)[0m  [1m[35mCOMMIT[0m
Dropped database 'test'
Created database 'test'
Run options: --seed 16566

# Running:

E

Finished in 0.012645s, 79.0817 runs/s, 0.0000 assertions/s.

  1) Error:
SchemaLoadTest#test_load_schema:
NoMethodError: undefined method `to_sym' for {:limit=>8}:Hash

        type = type.to_sym if type
                   ^^^^^^^
Did you mean?  to_s
               to_set
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/activerecord-7.0.4/lib/active_record/connection_adapters/abstract/schema_definitions.rb:412:in `column'
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/activerecord-7.0.4/lib/active_record/connection_adapters/abstract/schema_definitions.rb:246:in `primary_key'
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/activerecord-spanner-adapter-1.2.2/lib/active_record/connection_adapters/spanner/schema_statements.rb:53:in `create_table'
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/activerecord-7.0.4/lib/active_record/migration.rb:932:in `block in method_missing'
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/activerecord-7.0.4/lib/active_record/migration.rb:900:in `block in say_with_time'
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/3.1.0/benchmark.rb:296:in `measure'
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/activerecord-7.0.4/lib/active_record/migration.rb:900:in `say_with_time'
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/activerecord-7.0.4/lib/active_record/migration.rb:921:in `method_missing'
    /home/nownabe/src/github.com/nownabe/bug-report-activerecord-spanner/schema-load-ruby/db/schema.rb:14:in `block in <top (required)>'
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/activerecord-7.0.4/lib/active_record/schema.rb:55:in `instance_eval'
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/activerecord-7.0.4/lib/active_record/schema.rb:55:in `define'
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/activerecord-7.0.4/lib/active_record/schema.rb:50:in `define'
    /home/nownabe/src/github.com/nownabe/bug-report-activerecord-spanner/schema-load-ruby/db/schema.rb:13:in `<top (required)>'
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/activerecord-7.0.4/lib/active_record/tasks/database_tasks.rb:377:in `load'
    /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/activerecord-7.0.4/lib/active_record/tasks/database_tasks.rb:377:in `load_schema'
    /home/nownabe/src/github.com/nownabe/bug-report-activerecord-spanner/schema-load-ruby/test.rb:67:in `test_load_schema'

1 runs, 0 assertions, 0 failures, 1 errors, 0 skips
```
