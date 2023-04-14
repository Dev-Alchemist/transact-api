# Ruby on Rails MPESA Transactions API

This is a simple Ruby on Rails API that enables users to register, top up their accounts through MPESA, and send money to each other within the system. The system sends notifications to the recipient in the system and a confirmation email for each transaction.

## Features

* User authentication and authorization using the `devise` gem
* MPESA payment integration using the `mpesa` gem
* In-app email previews using the `letter_opener` gem
* Redis

Installation
1. Clone the repository to your local machine:
```bash
git clone git@github.com:your_username/transact-api.git
```
2. Change directory to the project folder:
```bash
cd transact-api
```
3. Install the required gems:
```bash
bundle install
```
4. Setup the database >> You can check the `` bin/setup`` file.
```bash
bin/rails db:prepare
```

## Usage
## Authentication
The API uses token-based authentication using the `devise_token_auth gem`. To register a new user, send a `POST` request to the /auth endpoint with the user's `email`, `password`, `password_confirmation`, and `phone` as parameters:

```python
POST /users/registrations
{
    "email": "john@example.com",
    "password": "password",
    "password_confirmation": "password",
    "phone_number": "2547112223**"
}

```
To log in, send a POST request to the /auth/sign_in endpoint with the user's email and password as parameters:

```python
POST /users/sessions
{
    "email": "john@example.com",
    "password": "password"
}
```
## Topups
To top up a user's account, send a `POST` request to the /topups endpoint with the user's `phone_number` and `amount` as parameters:
```python
POST /topups/charge
{
    "phone_number": "254712345678",
    "amount": "100"
}
```
## Transactions
To send money from one user's account to another, send a `POST` request to the /transactions endpoint with the recipient's email or phone_number and the amount to send as parameters
```python
curl -X POST \
  http://localhost:3000/transactions \
  -H 'Content-Type: application/x-www-form-urlencoded' \
  -H 'Authorization: Bearer <access_token>' \
  -d 'recipient_email=john@example.com&amount=10.00'
```
This will send 10.00 units of currency from the current user's account to the user with the email `john@example.com`.

To retrieve a list of all transactions for the current user, send a GET request to the /transactions endpoint:
```python
curl -X GET \
  http://localhost:3000/transactions \
  -H 'Authorization: Bearer <access_token>'
```
This will return a JSON array of all transactions made by the current user.