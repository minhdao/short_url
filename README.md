# README

This project provide a few endpoints to shorten a link into a specific format. E.g. enter URL https://codesubmit.io/library/react, it returns shorter URL http://short.est/GeAi9K

## Encode and Decode Logics
### Encode
The idea is to transform the input URL into a shorter representation. This can be done in different ways, but they should be able to accomplished the following:
1. Shorter
2. Unique (every input URL should have a unique encode form)
3. Handle collision

Even though there are ways to ensure no collision, such as mapping the input URL to shorter IDs (e.g. big int type). However, this way is not sustainable because we cannot control the length of the encoded URL, and the more URLs the system encode, the longer the encoded URL. This way is not choosen.

A better way in my opinion is to preform some hashing on the input URL, and then choose a fix number of characters in the hashed result to represent the input URL. There are many hashing algo to choose from but hashing a generated UUID with Ruby `SHA1.hexdigest` seem to be enough for the app's usecase. After hashing, I choose a fix length substring of the result.

More ways go generate unique Ids(token) can be found herer: `https://gist.github.com/mbajur/2aba832a6df3fc31fe7a82d3109cb626`

However, we want to shrink the size of the input URL, so collisions might happen sometimes. To handle this case, I have implemented a sliding window method to retry and choose a different substring in the hased value.

### Decode
After encoding is done successfully, we save a record in the database, as a Link, to represent the URL and the shorten URL. Since they are unique, we just need to look inside the links table for the orginal URL. No actual decoding needed

## Scaling
Because no state is kept in the app, so when we need to scale, we can create a new app server and use a load balancer to redirect traffics. Also, to improve the speed of the app, we might want to use some caching methods (Redis) to store the most visited links and return before calling to the database.

## Security Measure
1. JWT authentication to only allow valid user of the system to call encode and decode enpoints
2. There are also some concern about SQL injection, but Rails ActiveRecord already handle a lot of this concern when querying to the database.
3. Ensure that production environment is run in HTTPs to avoid data snippers.
4. User passwords hashed to avoid password leaks.
5. Handling user inputs and errors to avoid unexpected errors thrown.

## App Structure
The app is broken down into different small parts with different focus on each part.
### Controllers
Controller the flow the request and send back the response to the caller
### Services
Service encapsulates the core logics of the app. This is where the URL is encoded and decoded
### Models
Represents all the data needed for the app. 
E.g. User model represent a user of the app with data like `username`, `email`, `password` used to generate access token to access other endpoints.
E.g. Link model represent a link a user might send to the encode or decode. The link will have data such as orginal url, short url, etc. This is useful because we can use one to look up the other before deciding to do the actual encode/decode or not.
### Custom validtors
Support validation on the models. E.g. EmailValidator stores the logics to validate emails format used in the Link model.
### Domains
Supporting logics that might be used in differetn services. E.g. Security domain houses the logics for creating and validating the JWTs. This can be used in different services if need to.

## Flow of the app
1. Call `/users` to reate a new user with username, email, and password
2. Call `/auth/login` authenticate the user to get a JWT for accessing other enpoints
3. Call `/encode` to shorten an input URL
4. Call `/decode` to return a shorten URL back to its original URL

## APIs Info
There are four endpoints available at the moment:
1. `POST /users` to create a new user
2. `POST /authenticate` to authenticate a user and return a JWT used to access other endpoints
3. `POST /encode` to encode (shorten) an input URL
4. `GET /decode` to decode a short URL back to its original form

### `POST /users`
Send along with params: `username`, `email`, and `password` to create a new user.
E.g. `localhost:3000/users?username=dao&email=dao@gmail.com&password=123123123`

### `POST /auth/login`
Send along with params: `username`, and `password` to get JWT to use in encode and decode endpoint
E.g. `localhost:3000/auth/login?username=dao&password=123123123`
E.g. Reponse 
```
{
    "token": "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VybmFtZSI6ImRhbyIsImV4cCI6MTY3OTMwNjE3M30.JJcJavfrXahJQfSacPhmQuIN1YKZ8fHt9fTgvU0o_30"
}
```

### `POST /encode`
Send along with JWT token in Authentication header to encode a valid URL
E.g. Reponse
```
{
    "url": "https://helloworld.com/this/that",
    "encoded": "http://short.er/f4d92fa"
}
```

### `POST /decode`
Send along with JWT token in Authentication header to decode a valid URL
E.g. Reponse
```
{
    "url": "http://short.er/f4d92fa",
    "decoded": "https://helloworld.com/this/that"
}
```

### `Errors`
Validations are perform on each enpoints. For more info about the validations and errors, please refer to `spec`
E.g. Reponse error for `POST /users`
```
{
    "errors": {
        "email": [
            "has already been taken"
        ],
        "username": [
            "has already been taken"
        ]
    }
}
```

## Demo
Please use the info provided in the APIs section to make calls to `https://sleepy-peak-62516.herokuapp.com`

E.g. To create a new user
`POST https://sleepy-peak-62516.herokuapp.com/users/?username=user&email=user@gmail.com&password=12345`

## Run App Locally
Make sure that your local machine has Postgres installed.
Config the app and database inside database.yml. Change the `host`, `port`, `username`, and `password` to your settings.
You can run the test suite with `bundle exec rspec`

1. Clone the project from https://github.com/minhdao/short_url
2. Run `rails db:create` and `rails db:migrate`
3. Run `rails server`

You can make calls to APIs described in the APIs sections.

## Improvemnts
* Extract some configs values into `.env` to be more robust and secure.