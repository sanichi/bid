# README

This [website](https://bid.sanichi.me/) is for learning bridge bidding using spaced repitition.

To run/test locally:

* Install the version of ruby in `.ruby-version`.
* Run `bin/bundle install`.
* Overwrite `config/credentials.yml.enc` (which only has `secret_key_base`) with a new `config/master.key`.
* Make sure you have PostgreSQL running locally.
* Create the unversioned file `config/database.yml` something like this:
```
default: &default
  adapter: postgresql
  encoding: unicode
  pool: 5
  username: blah
  password: blah
development:
  <<: *default
  database: bid_development
test:
  <<: *default
  database: bid_test
```
* Run `bin/rails db:create`.
* Create at least one admin user with `bin/rails c`:
```
User.create!(name: "...", email: "...", password: "...", admin: true)
```
* Run the app locally on port 3000 with `bin/rails s`.
* Test by running `bin/rake`.
