# TradeSkillMaster (TSM) Setup & Gold Guide — WoW: Forever

## sniping operatios

- custom source

```trueval
# name this trueval
min(
    dbmarket,
    dbhistorical,
    dbregionsaleavg
)
```

sniping operation

```trueval
max(40% trueval, 95% VendorSell, 75% Destroy)
```

set the groups sniping operation to this

## auction operations

min
set to `ignore auctions without minimum`

```
max(first(125% SmartAvgBuy / 0.95, 80% avg(DBMarket, DBHistorical, DBRegionSaleAvg)), 115% VendorSell, 105% Destroy)

```

max
set to `post at normal price`

```
250% max(DBRecent, DBMarket, DBHistorical, DBRegionSaleAvg)
```

normal

```
130% max(DBRecent, DBMarket, DBHistorical, DBRegionSaleAvg)

```
