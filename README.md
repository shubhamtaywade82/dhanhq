Dhanhq
Dhanhq is a Ruby SDK to interact with the Dhan API for trading, portfolio management, market data retrieval, and more. This gem simplifies working with Dhan's extensive set of APIs, making it easier for developers to build trading applications.

Installation
Add the gem to your Gemfile:

```ruby
gem 'dhanhq'
```

Then execute:

```ruby
bundle install
```

Alternatively, install it directly:

```ruby
gem install dhanhq
```

Configuration
Before making any API calls, configure the gem with your Dhan API credentials:

```ruby
require 'dhanhq'


Dhanhq.configure do |config|
  config.access_token = 'your_access_token'
  config.client_id = 'your_client_id'
end
```

Replace your_access_token and your_client_id with your credentials provided by Dhan.

Usage
The gem provides methods to interact with the major endpoints of the Dhan API.

Orders
Place a New Order

```ruby
order_params = {
  dhanClientId: "123456",
  transactionType: "BUY",
  exchangeSegment: "NSE_EQ",
  productType: "INTRADAY",
  orderType: "MARKET",
  validity: "DAY",
  securityId: "11536",
  quantity: 10
}

response = Dhanhq::API::Trading::Orders.place(order_params)
puts response
```

Fetch All Orders

```ruby
response = Dhanhq::API::Trading::Orders.list
puts response
```

Cancel an Order

```ruby
order_id = "112111182198"
response = Dhanhq::API::Trading::Orders.cancel(order_id)
puts response
```

Portfolio
Retrieve Holdings

```ruby
response = Dhanhq::API::Trading::Portfolio.holdings
puts response
```

Retrieve Open Positions

```ruby
response = Dhanhq::API::Trading::Portfolio.positions
puts response
```

Convert a Position

```ruby
convert_params = {
  dhanClientId: "123456",
  fromProductType: "INTRADAY",
  toProductType: "CNC",
  positionType: "LONG",
  securityId: "11536",
  quantity: 10,
  exchangeSegment: "NSE_EQ"
}

response = Dhanhq::API::Trading::Portfolio.convert(convert_params)
puts response
```

Market Data
Fetch Last Traded Price (LTP)

```ruby
securities = { "NSE_EQ" => [11536, 49081] }
response = Dhanhq::API::Data::MarketFeed.ltp(securities)
puts response
```

Retrieve Historical Data

```ruby
historical_params = {
  securityId: "11536",
  exchangeSegment: "NSE_EQ",
  fromDate: "2024-01-01",
  toDate: "2024-02-01"
}

response = Dhanhq::API::Data::Historical.daily(historical_params)
puts response
```

Forever Orders
Create a Forever Order

```ruby
order_params = {
  dhanClientId: "123456",
  orderFlag: "SINGLE",
  transactionType: "BUY",
  exchangeSegment: "NSE_EQ",
  productType: "CNC",
  orderType: "LIMIT",
  validity: "DAY",
  securityId: "11536",
  quantity: 10,
  price: 1428,
  triggerPrice: 1427
}

response = Dhanhq::API::Trading::ForeverOrders.create(order_params)
puts response
```

Retrieve All Forever Orders

```ruby
response = Dhanhq::API::Trading::ForeverOrders.all
puts response
```

Statements
Fetch Ledger Report

```ruby
response = Dhanhq::API::Statements.ledger(from_date: "2024-01-01", to_date: "2024-01-31")
puts response
```

Fetch Trade History

```ruby
response = Dhanhq::API::Statements.trade_history(from_date: "2024-01-01", to_date: "2024-01-31", page: 0)
puts response
```

Development
Clone the repository:

```ruby
git clone https://github.com/your-username/dhanhq.git
```

Install dependencies:

```ruby
bundle install
```

Run tests:

```ruby
rspec
```

Make your changes, then open a pull request.

Contributing
Contributions are welcome! To contribute:

Fork the repository.
Create a new branch for your feature or bug fix.
Write your code, including tests.
Submit a pull request.
License
This gem is available as open-source under the terms of the MIT License.

Code of Conduct
Everyone interacting in the Dhanhq project's codebases, issue trackers, chat rooms, and mailing lists is expected to follow the code of conduct.
