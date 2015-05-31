# Overview

Bring up the topic of recruiters with a developer and you're likely to get [a colorful
response](https://hn.algolia.com/?query=recruiters&sort=byPopularity&prefix&page=0&dateRange=all&type=story).
As a developer, I used to feel this way myself. But then I learned to stop taking them personally
and to start accepting them as helpful agents for automating part of my job-finding workflow.

Recruiters-on-Rails is a Rails application that helps manage and assess recruiters as part of
a broader strategy for working with recruiters to find a better job.


# Installation

Recruiters-on-Rails is designed to be run locally on the Rails development server with
a PostgreSQL database.

## Prerequisites

- [Ruby 2+](https://www.ruby-lang.org/en/downloads/)
- [PostgreSQL 9+](http://www.postgresql.org/)
- [Bundler](http://bundler.io/)
- [Git](http://git-scm.com/)

For help setting up Rails, see [gorails.com](https://gorails.com/setup/).

## Recruiters-on-Rails

Install the application itself using git:

    git clone URL recruiters-on-rails

Install gems:

    cd recruiters-on-rails
    bundle install

## Database

Create your application's postgres database:

    # Use postgres command line interface
    sudo su - postgres
    psql

    # SQL commands
    CREATE USER recruiters_on_rails WITH PASSWORD 'recruiters_on_rails';
    CREATE DATABASE recruiters_on_rails;
    GRANT ALL PRIVILEGES ON DATABASE recruiters_on_rails TO recruiters_on_rails;
    CREATE DATABASE recruiters_on_rails_test;
    GRANT ALL PRIVILEGES ON DATABASE recruiters_on_rails_test TO recruiters_on_rails;
    ALTER ROLE recruiters_on_rails SUPERUSER;

Setup database:

    bundle exec rake db:setup
    bundle exec rake db:setup RAILS_ENV=test


# Usage

## Local Server

To start the the local server on port 3000:

    bundle exec rails server -b 0.0.0.0 -p 3000

You should be able to start adding recruiters at

    http://localhost:3000/

## Datatypes

- Recruiters: people who will help you land interviews and a job
- Pings: interactions with a recruiter that can raise their rating
- Merits/Demerits: points you can add or subtract to your recruiter rating
- Interviews: recruiters get points based on how you score the interviews they arrange for you
- Lists: groups of recruiters useful for mailing lists

I usually add recruiters only after I have sent them an email and they have responded in a
meaningful non-generic way.

I strongly recommend dealing with recruiters by email at the outset as this will be far
more efficient, especially as you develop scripts and templates for interacting with them.


# Development
## Tests
All tests:

    bundle exec rake test

Single test:

    bundle exec rake TEST=test/models/recruiters_test.rb
