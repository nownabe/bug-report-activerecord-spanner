# How to reproduce

Run Spanner emulator in advance.

## Setup

### Use this repository

Clone this repository and run:

```sh
export SPANNER_EMULATOR_HOST=localhost:9010
cd app_with_rspec
bundle install
rails spanner:instance:create
bundle exec rspec
```

### From scratch

```sh
export SPANNER_EMULATOR_HOST=localhost:9010
rails _7.0.4_ new app_with_rspec --skip-bundle --skip-test
cd app_with_rspec
rm -rf .git
vi Gemfile
bundle install
rails g rspec:install
vi config/database.yml
vi lib/tasks/spanner.rake # Patch for fixing bug
rails spanner:instance:create
rails db:create
rails db:migrate
vi spec/models/post_spec.rb
bundle exec rspec
```

## Result

Test code:

```ruby
require 'rails_helper'

RSpec.describe Post, type: :model do
  it do
    post = Post.new(text: "Hi!")
    post.save!
    expect(Post.find(post.id).text).to be_equal("Hi!")
  end
end
```

Output:

```ruby
❯ bundle exec rspec
F

Failures:

  1) Post 
     Failure/Error: post.save!
     
     ActiveRecord::StatementInvalid:
       Google::Cloud::InvalidArgumentError: 3:Syntax error: Unexpected identifier "SAVEPOINT" [at 1:1]
       SAVEPOINT active_record_1
       ^. debug_error_string:{UNKNOWN:Error received from peer ipv6:%5B::1%5D:9010 {grpc_message:"Syntax error: Unexpected identifier \"SAVEPOINT\" [at 1:1]\nSAVEPOINT active_record_1\n^", grpc_status:3, created_time:"2022-11-30T10:33:36.607687035+09:00"}}
     # ./spec/models/post_spec.rb:6:in `block (2 levels) in <top (required)>'
     # ------------------
     # --- Caused by: ---
     # GRPC::InvalidArgument:
     #   3:Syntax error: Unexpected identifier "SAVEPOINT" [at 1:1]
     #   SAVEPOINT active_record_1
     #   ^. debug_error_string:{UNKNOWN:Error received from peer ipv6:%5B::1%5D:9010 {grpc_message:"Syntax error: Unexpected identifier \"SAVEPOINT\" [at 1:1]\nSAVEPOINT active_record_1\n^", grpc_status:3, created_time:"2022-11-30T10:33:36.607687035+09:00"}}
     #   /home/nownabe/.asdf/installs/ruby/3.1.2/lib/ruby/gems/3.1.0/gems/grpc-1.50.0-x86_64-linux/src/ruby/lib/grpc/generic/active_call.rb:29:in `check_status'

Finished in 0.0844 seconds (files took 0.82786 seconds to load)
1 example, 1 failure

Failed examples:

rspec ./spec/models/post_spec.rb:4 # Post
```
