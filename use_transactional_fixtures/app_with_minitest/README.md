# How to reproduce

Run Spanner emulator in advance.

## Setup

### Use this repository

Clone this repository and run:

```sh
export SPANNER_EMULATOR_HOST=localhost:9010
cd app_with_minitest
bundle install
bin/rails spanner:instance:create
bin/rails test
```

### From scratch

```sh
export SPANNER_EMULATOR_HOST=localhost:9010
rails _7.0.4_ new app_with_minitest --skip-bundle
cd app_with_minitest
rm -rf .git
vi Gemfile
bundle install
vi config/database.yml
vi lib/tasks/spanner.rake # Patch for fixing bug
vi test/test_helper.rb # Patch for fixing bug
bin/rails spanner:instance:create
bin/rails g model Post text:string
bin/rails db:create
bin/rails db:migrate
vi test/models/post_test.rb
bin/rails test
```

## Result

This is the test code:

```ruby
require "test_helper"

class PostTest < ActiveSupport::TestCase
  # If you disable use_transactional_tests, this test works!
  # self.use_transactional_tests = false

  self.use_transactional_tests = true

  test "should be valid" do
    post = Post.new(text: "Hi!")
    post.save!
    assert_equal Post.find(post.id).text, "Hi!"
  end
end
```

Output:

```sh
❯ bin/rails test
Running 1 tests in a single process (parallelization threshold is 50)
Run options: --seed 12090

# Running:

E

Error:
PostTest#test_should_be_valid:
ActiveRecord::StatementInvalid: Google::Cloud::InvalidArgumentError: 3:Syntax error: Unexpected identifier "SAVEPOINT" [at 1:1]
SAVEPOINT active_record_1
^. debug_error_string:{UNKNOWN:Error received from peer ipv6:%5B::1%5D:9010 {grpc_message:"Syntax error: Unexpected identifier \"SAVEPOINT\" [at 1:1]\nSAVEPOINT active_record_1\n^", grpc_status:3, created_time:"2022-11-29T15:59:04.488789752+09:00"}}
    test/models/post_test.rb:11:in `block in <class:PostTest>'


rails test test/models/post_test.rb:9



Finished in 0.064076s, 15.6066 runs/s, 0.0000 assertions/s.
1 runs, 0 assertions, 0 failures, 1 errors, 0 skips

```
