# Resurrectism API

Live version running on https://api.resurrectism.space

## Cloud Infrastructure

Our api service is hosted on [render](https://render.com/) which is a PaaS (Platform-as-a-Service) Cloud Provider. The diagram below shows the interaction between the different components of our application

![Cloud Infrastructure](./cloud_Infrastructure.png)

## Continious Integration / Continious Deployment

Our `main` branch is protected and new commits can only be added via pull request. Pull requests need to be approved and must pass all of the CI (Github Actions) checks which include proper formatting, absence of linting errors and security vulnerabilities and of course passing tests.

Each new commit to `main` pushes the `main` branch to `production` only if all of the steps were successful. And each new commit to `production` triggers a new deploy on [render](https://render.com/).

This extra step has the added benefit of guaranteeing that the code on `main` is only deployed only if all of the steps were successful.

The diagram below shows the different steps of our CI/CD pipeline

![CI CD](./API_CI_CD.png)

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

### Hosts
The only way to access the API locally is through http://api.resurrectism.test:3000, because we guard against [DNS rebinding](https://en.wikipedia.org/wiki/DNS_rebinding) attacks so it will be necessary to include these two lines in your `/etc/hosts` file:
```
127.0.0.1 resurrectism.test  # Necessary only for the frontend-client
127.0.0.1 api.resurrectism.test
```

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

### Security

Run [brakeman](https://github.com/presidentbeef/brakeman) to check
the code for security vulenerabilites:
```sh
bundle exec brakeman
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
