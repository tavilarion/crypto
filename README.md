# Bitcoin price notification API using Grape 

### Running the api
1. Install docker and docker-compose from https://www.docker.com/get-started
2. Clone the project
3. Navigate to the project root folder
4. Create a `.env` file and copy the contents of `.env.example` in the new file
5. Run `docker-compose up` 
6. Wait for the services to start, might take several minutes
7. In any web browser, visit `http://localhost:9292/api/status` and you should see an output similar to `{"status":"ok","version":"0.0.1"}`

### API documentation
1. Using swagger for documentation
2. Visit https://petstore.swagger.io/
3. Enter `http://localhost:9292/api/swagger_doc` and click explore
4. You should now be able to:
    1. Register a user with email/password
    2. Authenticate (simple JWT) and receive a token
    3. With that token added in the mandatory header field (`Bearer: token`):
        1. Fetch the current price of a bitcoin (usd)
        2. Set a lower and upper threshold (usd) to be notified when exceeded
         
### Additional information

#### Run tests, rubocop, get an interactive console 
1. Run `docker ps` and copy the container id for any image that contains `crypto`
2. Run `docker exec -it <container_id> /bin/bash`
3. You can now:
    1. get an interactive console by running `ruby bin/console.rb`
    2. run tests by running `rspec`
    3. run rubocop by running `rubocop`

#### Application behaviour
1. Due to the limit on the number of requests to the pricing API
    1. the script in `bin/trigger.rb` calls the pricing api every 5 seconds to fetch the latest bitcoin price
    2. it then compares the price to the one already stored in redis
    3. if the price has changed, it updates the entry in Redis and triggers the notifications logic
    4. the price value stored in Redis is used in the rest of the application instead of calling the pricing API every time
    5. this script is intended for development and testing only
        1. in production, a lambda function in AWS will run recurrently, update the price in Redis and trigger the notifications 

2. To avoid flooding users with notifications
    1. The notification engine notifies users only once a day for every threshold
    2. When creating a new threshold, the user is notified immediately if it is exceeded
    3. Currently just logging a message to the console (can be seen in the terminal window where we ran `docker-compose`), pending implementation of a notifications service
    4. To test the recurring notifications engine behavior
        1. Create an exceeding threshold for a user using the API at https://petstore.swagger.io/
        2. You should see a message logged, user should be notified 
        3. Get an interactive terminal as described above 
        4. Manually set the `notified_at` value for the created threshold to `nil`
        5. Restart docker compose and you should see a message logged (the user was notified) once the services start
        6. Alternatively, create a threshold that is very close to the actual price and wait for the price to change