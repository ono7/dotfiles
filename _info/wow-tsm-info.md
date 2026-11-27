# TradeSkillMaster (TSM) Safe Setup — WoW: Forever

## 1. Group Architecture (Opt-In Whitelist)

- **Neutralize `Base Group`:**
  - Path: `/tsm` -> **Groups** -> **Base Group** -> **Operations**
  - Action: Unassign `#Default` from both **Auctioning** and **Vendoring**.
  - Result: Ungrouped items in bags are completely ignored during scans.
- **Personal / Protected Items:**
  - Group Name: `Personal - Do Not Sell`
  - Operations: Leave **Auctioning** and **Vendoring** unassigned (blank).
  - Contents: Food, water, bandages, potions, pet food, ammunition, gathering tools, swap gear.
- **Sell Groups (Explicit Opt-In Only):**
  - Create dedicated groups (e.g., `Auction - Trade Goods`, `Auction - BoE Gear`) and attach operations **only** to these groups.
- **Bank Isolation:**
  - Store long-term reserves, rare mats, and saved gear in the Bank (TSM scans bags only).

---

## 2. Auctioning Operation — Safe Price Floors & Fallbacks

Path: `/tsm` -> **Operations** -> **Auctioning** -> **[Your Sell Operation]** -> **Posting**

| Setting                    | Value / Formula                       | Purpose                                                                            |
| :------------------------- | :------------------------------------ | :--------------------------------------------------------------------------------- |
| **Amount Kept in Bags**    | `0` _(or custom reserve, e.g., `20`)_ | Retains a personal stack in bags before posting excess inventory.                  |
| **Minimum Price**          | `max(115% VendorSell, 75% DBMarket)`  | Guarantees profit above NPC vendor price (after 5% AH cut) and blocks cheap dumps. |
| **When Below Minimum**     | `Do Not Post`                         | Skips items when current auctions drop below your minimum floor.                   |
| **Maximum Price**          | `max(300% VendorSell, 150% DBMarket)` | Caps pricing against high outlier listings to avoid wasted deposit fees.           |
| **When Above Maximum**     | `Post at Normal Price`                | Lists at your normal market price instead of skipping or overpricing.              |
| **Normal (Regular) Price** | `max(150% VendorSell, 100% DBMarket)` | Lists at current local market average when no undercut is present.                 |

---

## 3. Vendoring Safety Rules

Path: `/tsm` -> **Operations** -> **Vendoring** -> **Sell Options**

- Do **not** attach a Vendoring operation to `Base Group` or `Personal - Do Not Sell`.
- Use **Sell Gray** / **Sell BoP** buttons manually at vendors rather than broad group scans.
- If auto-vendoring specific items you also use, set **Keep quantity** to your required reserve count.

---

## 4. UI Readability & Workflow Shortcuts

- **UI Scale:** `/tsm` -> **Settings** -> **General** -> **UI Scale** -> `1.1` to `1.25`
- **Quickly Add Items to Group:**
  1. Open `/tsm` -> **Groups** -> **[Target Group]** -> **Items**.
  2. Filter by text/bag or **Shift-click** items directly from your open bags/bank.
  3. Click **Add >>>**.
- **Tooltip Check:** Confirm TSM AuctionDB shows green/fresh data from the TSM Desktop App before running Post Scans.
