# Intial Setup

    docker-compose build
    docker-compose up mariadb
    docker-compose run short-app rails db:migrate
    docker-compose -f docker-compose-test.yml build

# To run migrations

    docker-compose run short-app rails db:migrate
    docker-compose -f docker-compose-test.yml run short-app-rspec rails db:test:prepare

# To run the specs

    docker-compose -f docker-compose-test.yml run short-app-rspec

# Run the web server

    docker-compose up

# Adding a URL

    curl -X POST -d "full_url=https://google.com" http://localhost:3000/short_urls.json

# Getting the top 100

    curl localhost:3000

# Checking your short URL redirect

    curl -I localhost:3000/abc

# URL Shortening Algorithm

Each new URL record has a sequential numeric ID. Since we want the shortest
possible URL string, and there are 62 total alphanumeric characters
(case-sensitive), the shortened URL is a base-62 representation of the ID. For
example, for ID 50, the shortened URL will be `"O"` (the capital letter O), and
for ID 1001, the shortened URL will be `"g9"`. To find the URL by short code,
the process is reversed, and we convert from the base-62 string to an integer. 

# Limitations/Bugs/To-do

* POSSIBLE BUG: If the number of stored URLs increases too much, and if we ever
  change the API to include routes with only alphanumeric characters in the URL,
  then we may end up with naming conflicts in the future. If we anticipate
  needing to change the API, we should do one of the following:
  * Change the shortening algorithm to skip conflicting shortcodes.
  * Add a prefix to the shortened URLs
  * Add a prefix to API URLs (e.g. "/api/v1/...")
