# Security (Threat Model)

## Introduction

The goal of this threat model is to **identify** and **document** potential security vulnerabilities in our infrastucture,
figure out a way to **detect** and create countermeasures to **safeguard** against them. We use the OWASP Top 10 as a guide
and go through each of the security risks and evaluate the measures we have already implemented and the risks that we are
still exposed to.

## Data Flow Diagram

![Data Flow Diagram](./threat-model-data-flow.png)

## Legend

Diagnosis - whether we are susceptible or not.

Measures - countermeasures we have taken or should take to mitigate the attack.

## Threats

### A01 Broken Access Control

#### Missing access controls for POST, PUT and DELETE

Measures:

- [x] JWT Middleware (to check proper authentication) attached to to all endpoints except login and sign-up routes.

#### Tampering with a JSON Web Token (JWT)

Measures:

- [x] Check that the JWT is signed with the server's `auth_secret`

#### CORS misconfiguration

Measures:

- [x] CORS enabled and only allowed for our frontend domain - https://resurrectism.space (since the request is not from the same origin
      as our API - https://api.resurrectism.space)

#### Cross Site Request Forgery (CSRF)

Measures:

- [x] CORS (see above)

- [x] State-changing operations are only done with `PUT/PATCH/POST/DELETE` requests

- [x] Cookies with `SameSite=Lax`, which only send the cookies along with GET requests

#### Force browsing to authenticated pages as unauthenticated user

Measures:

- [x] Frontend only allows access to authenticated pages for authenticated users. (even if a user bypasses the frontend check, the data will not be loaded since the API will return an `Unauthorized` Status Code)

### A02: Cryptographic failures:

#### Transmission of data in clear text

Measures:

- [x] All data is transmitted through HTTPS

#### Weak cryptographic algorithms or protocols

Measures:

- [x] Rails uses [bcrypt](https://en.wikipedia.org/wiki/Bcrypt) for password-hashing

- [x] The JWT library uses the HS256 symmetric signing method which can be [brute-forced](https://auth0.com/blog/brute-forcing-hs256-is-possible-the-importance-of-using-strong-keys-to-sign-jwts/) with small- and medium-sized keys (below 256 bits). We are protected against it since our secrets are 128 characters long which is `128*8=1024` bits in total.

### A03: Injection

#### SQL Injection:

Measures:

- [x] User data is sanitized by using positional handlers (user data is not inserted into raw SQL statements). We also do not use [Rails methods vulnerable to SQL injection](https://rails-sqli.org/)

#### Cross-Site Scripting (XSS)

Measures:

- [x] We are protected against all types of XSS (Reflected, Stored or DOM-based) because React doesn't render strings as html content. One has to explicitly use `dangerouslySetInnerHTML`, which of course we don't.

### A04 Insecure Design

#### Generation of Error Message Containing Sensitive Information

Measures:

- [x] For login specifically, we do not respond with the reason for unsuccessful login (e.g. email already exists, or password mismatch, or non-existent user) so an attacker cannot gain more context from failed login attempts.

### A05: Security Misconfiguration

#### Error handling reveals stack traces or other overly informative error messages to users

Measures:

- [x] API only returns validation errors and does not expose internal workings such as stack traces

#### The software is out of date or vulnerable

Measures:

- [x] GitHub's builtin dependabot feature notifies us of security vulnerabilities in our dependencies and how to fix them.

=============================================================================
