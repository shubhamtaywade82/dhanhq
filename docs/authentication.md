# Authentication Guide

This guide explains how to authenticate with the DhanHQ APIs for both individual traders and partners, along with managing static IPs, configuring TOTP, and validating access tokens via the User Profile endpoint.

## Individual Traders

Individual traders can access Trading APIs for free and generate tokens in two ways:

- Obtain a short-lived access token directly from the Dhan web platform.
- Use the OAuth-style flow with an API key and secret.

### Direct Access Token from Web

1. Log in to [web.dhan.co](https://web.dhan.co).
2. Navigate to **My Profile → Access DhanHQ APIs**.
3. Generate a 24-hour **Access Token**. Optionally, supply a Postback URL to receive order updates.

### API Key & Secret Flow

1. Log in to [web.dhan.co](https://web.dhan.co) and open **My Profile → Access DhanHQ APIs**.
2. Toggle to **API key** and provide:
   - App name
   - Redirect URL (used after the browser login step)
   - Optional Postback URL
3. Store the generated API key and secret (valid for 12 months).
4. Complete the three-step consent flow described below to obtain an access token.

#### Step 1: Generate Consent

```bash
curl --location --request POST 'https://auth.dhan.co/app/generate-consent?client_id={dhanClientId}' \
  --header 'app_id: {API key}' \
  --header 'app_secret: {API secret}'
```

- Response returns a `consentAppId` required for the browser-based login.

#### Step 2: Browser Login

Open the following URL in a browser or web view and complete the login and 2FA challenges:

```
https://auth.dhan.co/login/consentApp-login?consentAppId={consentAppId}
```

On success, the user is redirected to the configured Redirect URL with `tokenId` appended as a query parameter.

#### Step 3: Consume Consent

```bash
curl --location 'https://auth.dhan.co/app/consumeApp-consent?tokenId={Token ID}' \
  --header 'app_id: {API Key}' \
  --header 'app_secret: {API Secret}'
```

- Response includes the `accessToken`, user identifiers, and expiry timestamp.


### Avoiding the 24-Hour Expiry Limit

The access token that is generated directly from the Dhan web dashboard expires after 24 hours. For automated workloads you should rely on the API key & secret flow, because the key pair remains valid for 12 months and lets you programmatically mint a fresh access token whenever you need it. A typical automation looks like this:

1. Store the API key, secret, and (optionally) the TOTP seed as environment variables or in your secret manager.
2. Call **Generate Consent** (Step&nbsp;1) to obtain a `consentAppId`.
3. Complete the browser login (Step&nbsp;2). Enabling TOTP removes the need to wait for SMS/email OTPs, which makes headless or service-based logins practical.
4. Immediately exchange the resulting `tokenId` by calling **Consume Consent** (Step&nbsp;3) and cache the `accessToken` together with the returned `expiryTime`.
5. Schedule a refresh job that repeats Steps 1 and 3 before the cached token expires (for example, every 12 hours). Rotate the token in your application without restarting it.

If you still prefer the 24-hour token generated from the web UI, build a similar scheduler that alerts you shortly before expiry so you can rotate the token manually.

### Wiring API Credentials into the Ruby SDK

Below is a minimal Ruby script that exchanges a `tokenId` for an access token and injects it into the `Dhanhq` configuration. The script expects the API key, secret, client id, and the most recent `tokenId` (captured from the redirect in Step&nbsp;2) to be available as environment variables.

```ruby
require "json"
require "net/http"
require "uri"
require "dhanhq"

API_KEY     = ENV.fetch("DHAN_API_KEY")
API_SECRET  = ENV.fetch("DHAN_API_SECRET")
TOKEN_ID    = ENV.fetch("DHAN_TOKEN_ID")

uri = URI("https://auth.dhan.co/app/consumeApp-consent")
uri.query = URI.encode_www_form(tokenId: TOKEN_ID)

request = Net::HTTP::Get.new(uri)
request["app_id"] = API_KEY
request["app_secret"] = API_SECRET

response = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
  http.request(request)
end

body = JSON.parse(response.body)

Dhanhq.configure do |config|
  config.client_id    = body.fetch("dhanClientId")
  config.access_token = body.fetch("accessToken")
end

# Persist the token so background jobs and web workers can reuse it.
File.write("tmp/dhan_access_token", body.fetch("accessToken"))
```

By running this script on a schedule (for example via cron or a background job), your application always has a valid token in memory and on disk. You can load the stored token at boot time instead of hard-coding it:

```ruby
Dhanhq.configure do |config|
  config.client_id    = ENV.fetch("DHAN_CLIENT_ID")
  config.access_token = File.read("tmp/dhan_access_token").strip
end
```

If you automate Step&nbsp;2 by using the TOTP secret (available after enabling TOTP in Dhan Web), you can generate the 6-digit code with a library such as [`rotp`](https://github.com/mdp/rotp) and complete the flow without manual input. Otherwise, capture the `tokenId` during the manual login and feed it to the script above.
## Partners

Partners authenticate on behalf of their users via a similar three-step flow.

1. Obtain `partner_id` and `partner_secret` from Dhan.
2. Generate consent using partner credentials.
3. Redirect the user to Dhan for login and retrieve the resulting `tokenId`.
4. Consume consent to receive the access token and user profile metadata.

### Step 1: Generate Consent

```bash
curl --location 'https://auth.dhan.co/partner/generate-consent' \
  --header 'partner_id: {Partner ID}' \
  --header 'partner_secret: {Partner Secret}'
```

- Response returns `consentId` for the next step.

### Step 2: Browser Login

```
https://auth.dhan.co/consent-login?consentId={consentId}
```

- Successful login redirects to the partner-provided URL with a `tokenId` query parameter.

### Step 3: Consume Consent

```bash
curl --location 'https://auth.dhan.co/partner/consume-consent?tokenId={Token ID}' \
  --header 'partner_id: {Partner ID}' \
  --header 'partner_secret: {Partner Secret}'
```

- Response includes the `accessToken`, `expiryTime`, and user details (client ID, name, UCC, DDPI status).

## Static IP Management

Static IP whitelisting is mandatory for order placement APIs. You can configure primary and secondary IPs, each modifiable once every seven days. Use the following endpoints with the `access-token` header.

### Set IP

```bash
curl --request POST \
  --url https://api.dhan.co/v2/ip/setIP \
  --header 'Accept: application/json' \
  --header 'Content-Type: application/json' \
  --header 'access-token: {Access Token}' \
  --data '{
    "dhanClientId": "1000000001",
    "ip": "10.200.10.10",
    "ipFlag": "PRIMARY"
  }'
```

### Modify IP

```bash
curl --request PUT \
  --url https://api.dhan.co/v2/ip/modifyIP \
  --header 'Accept: application/json' \
  --header 'Content-Type: application/json' \
  --header 'access-token: {Access Token}' \
  --data '{
    "dhanClientId": "1000000001",
    "ip": "10.200.10.10",
    "ipFlag": "PRIMARY"
  }'
```

### Get IP

```bash
curl --request GET \
  --url https://api.dhan.co/v2/ip/getIP \
  --header 'Accept: application/json' \
  --header 'access-token: {Access Token}'
```

## Time-Based One-Time Password (TOTP)

TOTP provides an alternative to SMS/email OTPs for API-only flows. Enable it from **Dhan Web → DhanHQ Trading APIs → Setup TOTP**, confirm with an OTP, then scan the QR code or enter the provided secret into an authenticator app. After enrollment, TOTP appears as the default second factor for partner logins and API key flows.

## User Profile Endpoint

Use the profile endpoint to validate access tokens and review account status:

```bash
curl --location 'https://api.dhan.co/v2/profile' \
  --header 'access-token: {JWT}'
```

The response contains:

- `dhanClientId`
- Token validity timestamp
- Enabled trading segments
- DDPI and MTF statuses
- Data API subscription status and validity

---

For more information, refer to the official DhanHQ API documentation.
