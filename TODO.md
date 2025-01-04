Validating request parameters using Dry::Validation contracts is crucial to ensure the correctness of API requests before they are sent. Based on the Dhanhq V2 API documentation you provided, here are the endpoints that require validation and the parameters that should be validated:

Endpoints Requiring Validations

1. Orders
   API Endpoints:

/orders (Place a new order)
/orders/{order-id} (Modify a pending order)
/orders/slicing (Place a sliced order)
Why Validate?

These endpoints involve critical trading operations where invalid parameters (e.g., quantity, price) could result in financial loss or API errors.
Validation Parameters:

transactionType (Required, must be "BUY" or "SELL")
exchangeSegment (Required, must be a valid segment from Constants::EXCHANGE_SEGMENTS)
productType (Required, must match Constants::PRODUCT_TYPES)
orderType (Required, must match Constants::ORDER_TYPES)
validity (Required, must match Constants::VALIDITY_TYPES)
securityId (Required, string)
quantity (Required, integer > 0)
price (Optional, float > 0 for LIMIT orders)
triggerPrice (Required for STOP_LOSS orders, float > 0)

2. Portfolio
   API Endpoints:

/positions/convert (Convert position)
Why Validate?

Converting positions between intraday and delivery modes requires strict validation to ensure valid inputs.
Validation Parameters:

fromProductType (Required, must match Constants::PRODUCT_TYPES)
toProductType (Required, must match Constants::PRODUCT_TYPES)
positionType (Required, must be "LONG" or "SHORT")
securityId (Required, string)
convertQty (Required, integer > 0)

3. Forever Orders
   API Endpoints:

/forever/orders (Create Forever Order)
/forever/orders/{order-id} (Modify Forever Order)
Why Validate?

Forever orders involve additional parameters (orderFlag, triggerPrice, etc.) that must conform to specific rules.
Validation Parameters:

orderFlag (Required, must be "SINGLE" or "OCO")
transactionType (Required, must be "BUY" or "SELL")
productType (Required, must match Constants::PRODUCT_TYPES)
price1, triggerPrice1, quantity1 (Conditional, required for OCO orders)
legName (Required for modifying OCO orders, must be "ENTRY_LEG" or "TARGET_LEG")

4. Funds
   API Endpoints:

/margincalculator (Calculate margin)
Why Validate?

Calculating margins involves parameters like quantity, price, and transactionType that require validation for correctness.
Validation Parameters:

transactionType (Required, must be "BUY" or "SELL")
exchangeSegment (Required, must match Constants::EXCHANGE_SEGMENTS)
quantity (Required, integer > 0)
price (Required, float > 0)
triggerPrice (Conditional, required for STOP_LOSS orders)

5. Historical Data
   API Endpoints:

/charts/historical (Daily Historical Data)
/charts/intraday (Intraday Historical Data)
Why Validate?

Validating fromDate and toDate ensures that date ranges are logical and formatted correctly.
Validation Parameters:

securityId (Required, string)
exchangeSegment (Required, must match Constants::EXCHANGE_SEGMENTS)
fromDate, toDate (Required, date format YYYY-MM-DD)

6. Option Chain
   API Endpoints:

/optionchain (Get Option Chain)
/optionchain/expirylist (Get Expiry List)
Why Validate?

Option Chain APIs rely on parameters like UnderlyingScrip and Expiry that must be accurate.
Validation Parameters:

UnderlyingScrip (Required, integer > 0)
UnderlyingSeg (Required, must match Constants::EXCHANGE_SEGMENTS)
Expiry (Optional, date format YYYY-MM-DD)

7. Statements
   API Endpoints:

/ledger (Get Ledger Report)
/trades (Get Historical Trades)
Why Validate?

Ensuring valid date ranges and pagination for historical data requests.
Validation Parameters:

from_date, to_date (Required, date format YYYY-MM-DD)
page (Optional, integer >= 0)
Endpoints Without Strict Validation
Some endpoints, like simple GET requests for fetching lists (e.g., /holdings, /positions, /forever/all), do not require strict validation since they have no or minimal parameters.

Summary
For all the above endpoints, Dry::Validation contracts can enforce rules to ensure correctness, prevent invalid requests, and reduce API errors.
