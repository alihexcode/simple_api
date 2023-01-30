# Recipe API

## Requirements
- Rails v7.0.1
- Ruby v3.0.0
- MySQL database
- JBuilder to render JSON response
- Pagy gem for pagination with Link header standard
- Rswag for API documentation
- Rspec for testing
- Simplecov for test coverage

## Running the project
1. Clone the repository
    ```
    git clone git@github.com:asadt93/simple_rails_api.git
    ```
2. Install dependencies
    ```
    bundle install
    ```
3. Set up the database configuration in `config/database.yml`
4. Create and migrate the database
    ```
    rails db:create
    rails db:migrate
    ```
5. Start the server
    ```
    rails s
    ```

## Rswag documentation
To generate Rswag documentation, run
  ``` rake rswag:specs:swaggerize ```

## Check code style with Rubocop
To check the code style, run
```
rubocop
```

## Rspec tests and Test coverage
To run Rspec tests, run
```
bundle exec rspec
```

The coverage report will be generated in `coverage/index.html`
in a debian/ubuntu Terminal,

```
xdg-open coverage/index.html
```

## JSON response
The JSON response is rendered using JBuilder, you can find the view templates in `app/views` directory.

## Pagination
Pagination is handled using the Pagy gem, with Link header standard. You can specify the page number and number of items per page in the API request parameters.
