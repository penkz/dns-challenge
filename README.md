# DNS Challenge

### Ruby Version
2.6.5

### Rails Version
6.0.2.1

## Running the project

### Requirements
For running this project you'll need to have [Docker](https://docs.docker.com/compose/) and [Docker Compose](https://docs.docker.com/compose/) installed on your system
On the root directory we have the `Dockerfile` and `docker-compose.yml` files that contains all the configurarion for building the docker images and setting up the environment.

### Build the containers

```shell
docker-compose build
```
If you get a message about not having permission on the tmp/db folder, you can fix it by running:
```shell
sudo chmod 755 -R tmp/db
```
### Install dependencies
Run bundle to install the project's dependencies:
```shell
docker compose run web bundle install
```
### Create the DB and run all migrations
```shell
docker-compose run web rails db:create db:migrate
```
### Spin up the containers
```shell
docker-compose up
```
The application should be available at `http://localhost:3000`

### Needs a console?
```shell
docker-compose run web rails console
```
### Want to run the tests?
After building the docker images you can run the tests using the following command:

```shell
docker-compose run web bundle exec rspec
```

# Interacting with the API
You can interact with the API with using [cURL](https://curl.haxx.se/) or with other tools like Postman or Insomnia
Here's how to interact with it using cURL:

### Creating new DNS records
```shell
curl -X POST "http://localhost:3000/dns_records" -H "Content-Type: application/json" \
-d '{
    "dns_records": {
        "ip": "1.1.1.1",
        "hostnames_attributes": [
            { "hostname": "dolor.com" },
            { "hostname": "ipsum.com" }
          ]
        }
    }'
```

### Querying DNS Records
```shell
curl -X GET "http://localhost:3000/dns_records?page=1" -H "Content-Type: application/json"
```

### Including specific DNS Records
To requrest for specific DNS Records pass the `includes` params as a comma separated string
```shell
curl -X GET "http://localhost:3000/dns_records?page=1&includes=dolor.com,ipsum.com" -H "Content-Type: application/json"
```

### Excluding specific DNS Records
To exclude DNS Records from the query pass the `excludes` params as a comma separated string
```shell
curl -X GET "http://localhost:3000/dns_records?page=1&excludes=dolor.com,lorem.com" -H "Content-Type: application/json"
```

### It's also possible to mix and match `inlcudes` and `excludes`
```shell
curl -X GET "http://localhost:3000/dns_records?page=1&includes=sit.com&excludes=dolor.com,lorem.com" -H "Content-Type: application/json"
```
