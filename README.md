# Resurrectism API

Live version running on https://api.resurrectism.space  

## Local Development

### Prerequisites

The following instructions have been tested  **only** on `macOS`. Some adjustments for different operating system might be necessary

#### Ruby version
The required ruby version can be seen in the `.ruby-version` file. We recommend using [rbenv](https://github.com/rbenv/rbenv) for managing multiple ruby versions.

#### Bundler
The Rails ecosystem uses [bundler](https://bundler.io/) for managing dependencies. If you already have a ruby version installed, run this command in your terminal
```sh
gem install bundler
```

#### PostgreSQL
Having a running [PostgreSQL](https://www.postgresql.org/) database server is necessary to run the API

### Running the API 

Install dependencies:
```sh
bundle install
```

Create database (Database connection has to be active):
```sh
bundle exec db:create
```

Migrate database models:
```sh
bundle exec db:migrate
```

Run the application:
```sh
bundle exec rails s
```

### Formatting/Linting

Check linting errors with:
```sh
bundle exec rubocop
```

Fix (if possible) linting errors with:
```sh
bundle exec rubocop -A 
```

### Testing

Local testing requires an active database connection.

Run all specs with:
```sh
bundle exec rspec
```

Run specific spec file with
```sh
bundle exec rspec ./path/to/file
```

## Deployment

Our `main` branch is protected and new commits can only be added via pull request. Pull requests need to be approved and must pass all of the CI checks which include proper formatting, absence of linting errors and passing tests.

The API is automatically deployed on every new commit to `main` by [render](https://render.com/)
