#!/usr/bin/env bash
# Render build script for Rails
set -o errexit

bundle install
bundle exec rails assets:precompile
bundle exec rails db:migrate
