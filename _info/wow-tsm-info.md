# TradeSkillMaster (TSM) Setup & Gold Guide — WoW: Forever

## 1. Group Architecture (Opt-In Whitelist)

- **Neutralize `Base Group`:**
  - Path: `/tsm` -> **Groups** -> **Base Group** -> **Operations**
  - Action: Unassign `#Default` from **Auctioning** and **Vendoring**.
  - Result: Ungrouped items in bags are ignored by default during scans.
- **Lock Down `#Default` Operation (Global Safety Net):**
  - Auctioning (`#Default` -> **Posting**): Set **Post cap** to `0`, **Minimum price** to `999999g`, and **When below minimum** to `Don't Post Items`.
  - Vendoring (`#Default` -> **Sell Options**): Set **Keep quantity** to `9999` (or leave unassigned).
- **Personal / Protected Items:**
  - Group Name: `Personal - Do Not Sell`
  - Operations: Leave **Auctioning** and **Vendoring** unassigned (blank).
  - Contents: Food, water, bandages, potions, pet food, ammunition, gathering tools, swap gear.
- **Sell Groups (Explicit Opt-In Only):**
  - Create dedicated groups (e.g., `Materials`, `BoE Gear`) and attach operations **only** to those groups.
- **Bank Isolation:**
  - Keep long-term reserves, rare mats, and saved gear in the Bank (TSM Auctioning scans bags only).

---

## 2. Materials / Trade Goods Operation (Pure `DBMarket`)

Path: `/tsm` -> **Operations** -> **Auctioning** -> **[Materials Operation]** -> **Posting**

| Setting                                | Recommended Value                | Notes                                                                                                |
| :------------------------------------- | :------------------------------- | :--------------------------------------------------------------------------------------------------- |
| **Auction duration**                   | `8 Hours` _(or `24 Hours`)_      | Matches _WoW: Forever_ options (`2h`, `8h`, `24h`); avoid `2h` unless actively relisting.            |
| **Post cap**                           | `200` to `500` _(single number)_ | Prevents dumping massive inventory walls all at once.                                                |
| **Amount kept in bags**                | `0` _(or custom reserve)_        | Retains a personal stack in bags before posting extras.                                              |
| **Don't post after this many expires** | `0` _(or `3`–`5`)_               | Stops burning deposit gold on stagnant items if set to a small count.                                |
| **Undercut amount**                    | `1c` _(or `0c`)_                 | Type `1c` and press **Enter** to commit; if the field locks/reverts, run `/reload` or leave at `0c`. |
| **Minimum price**                      | `55% DBMarket` _(or `70%–75%`)_  | Higher floor skips small cheap stacks so you wait for higher walls; `55%` moves stock faster.        |
| **When below minimum**                 | `Don't Post Items`               | Blocks posting when current buyouts drop below your floor.                                           |
| **Normal price**                       | `105% DBMarket`                  | Captures a slight premium when leading or resetting the market.                                      |
| **Maximum price**                      | `150% DBMarket`                  | Caps ceiling pricing to avoid overpriced expirations.                                                |
| **When above maximum**                 | `Post at Normal Price`           | Posts at normal market value instead of skipping or overpricing.                                     |

---

## 3. BoE Gear / Niche Items Operation

Path: `/tsm` -> **Operations** -> **Auctioning** -> **[BoE Gear Operation]** -> **Posting**

| Setting                                | Recommended Value                                              | Notes                                                                           |
| :------------------------------------- | :------------------------------------------------------------- | :------------------------------------------------------------------------------ |
| **Auction duration**                   | `24 Hours`                                                     | Suits slower-moving gear and niche items.                                       |
| **Minimum price**                      | `max(115% first(VendorSell, 0c), 65% DBMarket)`                | Protects against selling below vendor value (after 5% AH cut) or dumping cheap. |
| **When below minimum**                 | `Don't Post Items`                                             | Skips items priced below your floor (vendor or market).                         |
| **Normal price**                       | `max(150% first(VendorSell, 0c), 130% DBMarket, DBHistorical)` | Uses `DBHistorical` to resist short-term price dips on slower items.            |
| **Maximum price**                      | `max(300% first(VendorSell, 0c), 250% DBMarket)`               | Allows wider upside on scarce gear.                                             |
| **When above maximum**                 | `Post at Normal Price`                                         | Avoids extreme outlier prices that expire unsold.                               |
| **Don't post after this many expires** | `4`                                                            | Caps deposit losses on slow or low-demand gear.                                 |

---

## 4. Workflow & Troubleshooting Notes

- **Loving Items From an Imported Group to `Personal - Do Not Sell`:**
  1. Select `Personal - Do Not Sell` in `/tsm` -> **Groups** -> **Items**.
  2. Enable **Show Grouped Items** (or filter by item name/bag) so items already inside an imported group appear.
  3. Select the items you want to keep and click **Move >>>** / **Add >>>**.
- **UI Scale:** `/tsm` -> **Settings** -> **General** -> **UI Scale** -> `1.1` to `1.25`.
- **Undercut Field Won't Change to `1c`:** Enter `1c` (lowercase `c`) and press **Enter**; if it snaps back, run `/reload` and test again, or keep `0c` if the input box remains locked.
