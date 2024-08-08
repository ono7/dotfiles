# AWS Networking basics

(https://skillbuilder.aws)

## core networking (network foundations)

- Amazon VPC

  - uses a CIDR block e.g. `10.0.0.0/8`
    - 2nd first usable address `10.0.0.1` is used for the gateway.
    - 3rd IP address `10.0.0.2` is used for DNS
    - 4th address `10.0.0.3` is reserved in case it is needed
    - If you have 16 IPs only 11 can be used after the reservations above

- AWS Transit gateway
- AWS PrivateLink - allows vpcs and other services to talk to eachover without
  using internet gateway (IGW) or NAT gateways

- NAT gateway - servers can have a default route with the nat gateway id as the
  destination to get out to the internet `0.0.0.0/0 nat-id`

## Edge networking

Amazon cloudFront (CDN)
Amazon Route53 (DNS/Global DNS)
AWS Global Accelerator (works at layer 7)

## Hybrid connectivity

AWS Direct Connect
AWS Site-to-site VPN
AWS Client VPN
AWS Cloud WAN

## Application Networking

AWS App mesh
Amazon API Gateway
AWS Cloud backup
