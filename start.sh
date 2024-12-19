#!/bin/bash

# Start Rails server in the background
./bin/rails server

# Start Sidekiq in the foreground
bundle exec sidekiq
