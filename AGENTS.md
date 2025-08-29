# Agent Guidelines for Bid Application

## Build/Test/Lint Commands
- **Run all tests**: `bundle exec rspec`
- **Run single test file**: `bundle exec rspec spec/features/problem_spec.rb`
- **Run single test**: `bundle exec rspec spec/features/problem_spec.rb:10`
- **Database setup**: `rails db:create db:migrate db:seed`
- **Start server**: `rails server` or `bundle exec puma`
- **Asset precompilation**: `rails assets:precompile`

## Code Style Guidelines
- **Language**: Ruby 3.x with Rails 8.0.2.1
- **Views**: Use HAML templates, not ERB
- **CSS**: Use SASS (.sass files), Bootstrap 5 framework
- **Constants**: Use SCREAMING_SNAKE_CASE (e.g., `MAX_EMAIL = 50`)
- **Methods**: Use snake_case, keep private methods at bottom
- **Validations**: Group related validations together
- **Dependencies**: Always use `inverse_of` for associations when possible
- **Error handling**: Use `rescue_from` in controllers, return flash messages for validation errors
- **Database**: PostgreSQL with ActiveRecord migrations
- **Testing**: RSpec with FactoryBot, Capybara for feature tests
- **Authorization**: Use CanCanCan for permissions
- **String handling**: Use `squish!` for normalizing whitespace, `downcase` for emails