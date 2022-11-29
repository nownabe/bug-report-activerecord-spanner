# frozen_string_literal: true

require "bundler/inline"

gemfile(true) do
  source "https://rubygems.org"
  git_source(:github) { |repo| "https://github.com/#{repo}.git" }

  gem "google-cloud-spanner"

  # gem "activerecord", "7.0.4"
  gem "activerecord", github: "nownabe/rails", branch: "schema-migrations-version-type"
  # gem "activerecord-spanner-adapter", "1.2.2"
  gem "activerecord-spanner-adapter", github: "nownabe/ruby-spanner-activerecord", branch: "schema-load-ruby"
end

require_relative "../test"
