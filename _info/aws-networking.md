# AWS Networking basics

(https://skillbuilder.aws)

`IGW / Virtual Private Gateway -> Router (AWS managed) -> Route table -> Network
ACL -> Subnet -> Security Group (AWS resource aware) -> Instance (1 or more EC2 servers)`

- `Gateways` - connect networks

- `Routers` - Deliver data within a network

- `Transit Gateway` - Connects VPCs, AWS accounts, and on-prem networks to a
  single gatweway.

- `Direct connect gateway` - Connects VPC spanned across regions

- `Virtual Gateway` - allows applications that are outside of your network mesh,
  to talk to services inside

## VPC Peering (one-to-one connections)

allows communication between two isolated VPCs using their private IP addresses.
VPC Peers can span `AWS accounts` and regions, data is encrypted by AWS..

- used for connecting vendor/partner services to your services or vice-versa
- give security audits access to your VPC
- Split applications to minimize the impact when there is an outage

  **_ VPC PEERING is ONE to ONE Connection _** care should be taken not to try to
  mesh services

- data transfers within a VPC availability zone are free of charge, data that
  traverses availability zones is charged.

## Transit Gateway (one-to-many connections)

- can be used to connect to on-prem networks
- data is encrypted by aws
- inter region peering connects transit gateways
- SDWAN connections are billed hourly (data transfers)

## PrivateLink Gateways (secure non-internet routed)

- encrypted by AWS
- used to connect VPCs, AWS Accounts, privately (not over the internet)

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
