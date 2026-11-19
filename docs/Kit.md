# OSPOS Item Kit Manual

## 1. Purpose

An **Item Kit** is a reusable bundle of one or more existing OSPOS items. It is used to quickly add the components of a package, bundle, set, or assembled product to a sale or receiving.

Examples include:

- Computer bundle containing a laptop, monitor, mouse, and keyboard
- Meal kit containing one main item and multiple side items
- Cleaning kit containing a bottle, mop, and gloves
- Service package containing multiple service or inventory items

An item kit is not generally a separate physical stock item. Its components are the items whose inventory quantities are increased or reduced.

## 2. Module Overview

The Item Kits module is one of the main OSPOS modules. It provides:

- Adding and updating item kits
- Deleting item kits
- Searching item kits by ID, barcode, name, or description
- Assigning component items and quantities
- Assigning an item-kit display sequence
- Configuring kit-level discounts
- Configuring component pricing
- Configuring component printing on receipts and invoices
- Calculating kit cost and retail price
- Generating barcodes for selected kits

## 3. Key Components

| Component | Database or code name | Purpose |
|---|---|---|
| Item Kit | `item_kits` | Stores kit-level information |
| Kit Component | `item_kit_items` | Links a kit to component items and quantities |
| Component Item | `items` | Stores each physical or service item |
| Parent Kit Item | `item_kits.item_id` | Optional item record used to represent the kit itself |
| Sales library | `Sale_lib` | Expands kits and component lines in sales |
| Receiving library | `Receiving_lib` | Expands kits in purchase/receiving transactions |
| Item Kits controller | `Item_kits` | Provides manage, create, edit, delete, search, and barcode actions |

## 4. Data Relationship

The core relationship is:

```text
Item Kit
  └── one or more Item Kit Components
        └── each component references an Item
```

This is a **many-to-many** relationship between item kits and items, with the `item_kit_items` table acting as the link table.

```text
item_kits (1) ── (many) item_kit_items (many) ── (1) items
```

### 4.1 `item_kits` Table

The kit header table stores:

| Field | Meaning |
|---|---|
| `item_kit_id` | Unique internal kit ID |
| `item_kit_number` | Optional barcode or kit number |
| `name` | Kit name |
| `description` | Kit description |
| `item_id` | Optional parent item record |
| `kit_discount` | Kit discount amount or percentage |
| `kit_discount_type` | `0` for percentage or `1` for fixed discount |
| `price_option` | Controls which component lines receive a price |
| `print_option` | Controls which component lines are printed |

The parent item relationship is optional:

```text
item_kits.item_id -> items.item_id
```

### 4.2 `item_kit_items` Table

The kit-component table stores:

| Field | Meaning |
|---|---|
| `item_kit_id` | Kit that owns the component |
| `item_id` | Component item |
| `quantity` | Component quantity |
| `kit_sequence` | Display or processing order |

Component quantities support fractional values with a database precision of `DECIMAL(15,3)`.

Deleting a kit removes its component rows. Deleting a component item cascades its kit-component relationship when the database foreign key constraints are active.

## 5. Difference Between a Kit and a Normal Item

| Normal item | Item kit |
|---|---|
| Usually represents one physical or service item | Represents a bundle or collection |
| Has its own stock quantity | Normally has no independent stock quantity |
| Sale updates that item directly | Sale expands the kit into component items |
| Receiving updates that item directly | Receiving expands the kit into component quantities |
| Identified by an item number | Identified by its kit number/barcode or `KIT <item_kit_id>` |

## 6. Parent Kit Item

A kit can optionally reference an existing item record as a **Kit Item**.

The parent item is useful when the kit should have:

- A name, category, and description
- A unit price
- A cost price
- Barcode and item-number behavior
- Tax configuration
- `ITEM_KIT` item-type classification

The kit itself may have a name and description, while the selected parent item supplies item-level information.

### When to use a parent kit item

Use a parent kit item when:

- The kit should appear as a chargeable item
- The kit needs an item-level unit or cost price
- The kit needs to be included as a line on a sale
- The kit should be searchable as an item in item-kit search behavior

### When a parent kit item is not needed

A parent item is optional. If none is selected, the kit still works as a bundle, and the component item prices can be used to calculate the kit retail price.

## 7. Creating a New Item Kit

### 7.1 Open the Item Kit Form

1. Open **Item Kits** from the OSPOS menu.
2. Select **New Item Kit**.
3. Complete the kit fields.
4. Add one or more component items.
5. Save the kit.

### 7.2 Barcode

Enter an optional Item Kit barcode or kit number.

Use a unique value unless duplicate barcode rules are explicitly allowed in OSPOS configuration.

The system also recognizes kits entered in this internal format:

```text
KIT <item_kit_id>
```

For example:

```text
KIT 12
```

The form also supports a custom barcode, when configured.

### 7.3 Kit Name

Enter a descriptive name. The name is required.

Use names that:

- Identify the complete package
- Are easy to search
- Do not rely only on abbreviations
- Do not change frequently

Example:

```text
Office Starter Kit
```

### 7.4 Kit Item

Optionally select an existing item to be the parent item for the kit.

To clear a selected parent item, clear the **Kit Item** search field.

### 7.5 Kit Discount Type

Choose one of:

| Type | Constant | Behavior |
|---|---|---|
| Percentage | `PERCENT = 0` | Applies the discount as a percentage |
| Fixed | `FIXED = 1` | Applies a fixed discount amount |

A discount configured on the kit is used when the kit is added to a sale. A fixed discount is capped so it cannot reduce an item price below the applicable fixed-discount behavior.

### 7.6 Discount

Enter the discount value:

- Percentage example: `10`
- Fixed example: `5.00`

The unit is determined by Discount Type.

In sale handling:

- If the existing customer/sale discount and kit discount use the same type, the larger discount is used.
- If the types differ, the kit discount replaces the current discount and its configured type is used.

## 8. Price Options

Price options control whether component lines receive prices when the kit is added to a sale.

### 8.1 Kit and Components

**Constant:** `PRICE_ALL`

This option applies component prices and includes component items as priced sale lines.

Use this when all kit components should be shown and charged individually.

### 8.2 Kit Only

**Constant:** `PRICE_KIT`

This option normally prices only the parent kit item. Component items have zero prices.

Use this when the kit has one bundled price and components should not be charged separately.

This option also depends on an item record with `item_type = ITEM_KIT` being available as the parent item.

### 8.3 Kit and Stock

**Constant:** `PRICE_KIT_ITEMS`

This option includes component prices for stocked components and excludes or zeros lines that are configured as non-stock items.

Use this for mixed bundles containing both stocked and non-stock items when only inventory items should contribute to the transaction price.

### Price Option Summary

| Option | Parent kit line | Stocked components | Non-stock components |
|---|---:|---:|---:|
| Kit and Components | Optional | Priced | Priced |
| Kit Only | Priced | Zero price | Zero price |
| Kit and Stock | Optional | Priced | Zero price |

## 9. Print Options

Print options control whether component lines appear on a receipt or invoice.

### 9.1 All

**Constant:** `PRINT_ALL`

Includes all kit component lines.

### 9.2 Priced Only

**Constant:** `PRINT_PRICED`

Includes only component lines with a price greater than zero.

### 9.3 Kit Only

**Constant:** `PRINT_KIT`

Prints the kit line but only when the line is identified as an item kit.

### Print Option Summary

| Option | Components printed | Typical use |
|---|---|---|
| All | All component lines | Transparent itemized bundles |
| Priced Only | Only non-zero priced lines | Hide free or bundled components |
| Kit Only | Kit/parent line only | Show a single package name |

The print option is stored with sale items and may affect invoice and receipt output.

## 10. Adding Components

The kit form contains an item search field and a component table.

For each component:

1. Search for an item.
2. Select the item from the autocomplete result.
3. Set **Sequence**.
4. Set **Quantity**.

### Quantity

Quantity is the amount of the component included in one kit.

Examples:

| Kit | Component | Quantity |
|---|---|---:|
| PC Bundle | Monitor | 1 |
| PC Bundle | Keyboard | 1 |
| Office Kit | Pen | 12 |
| Meal Kit | Sauce | 0.250 |

Adding the same item again to the component table increments the quantity instead of creating a duplicate component row.

### Sequence

Sequence controls the kit-component display order.

- Lower values appear earlier.
- Components are retrieved in ascending sequence.
- The default sequence is `0`.

Sequence should be set consistently when an operator needs predictable receipt or form ordering.

## 11. Cost and Retail Price Calculation

The management screen calculates totals for each kit:

### Cost price

The total kit cost is calculated as:

```text
Sum(component cost price × component quantity)
```

### Retail or unit price

The unit price starts with:

- The parent kit item's unit price, when a parent kit item exists
- Otherwise, `0`

For components, the unit price is added according to the kit price option:

- `Kit and Components`: add all component prices
- `Kit and Stock`: add only component items with `stock_type = HAS_STOCK`
- `Kit Only`: do not add component prices

The configured kit discount is then deducted:

- Percentage discount: percentage × calculated kit unit price
- Fixed discount: fixed amount

The resulting unit price is used in kit management and barcode views.

## 12. Saving a Kit

The save process:

1. Saves or updates kit header information.
2. Uses the kit primary key to determine insert versus update.
3. Creates or updates the component relationship.
4. Deletes existing component rows before inserting the submitted component list.
5. Completes in a database transaction.

For a new kit, the system uses the generated `item_kit_id` for component rows.

## 13. Searching and Managing Kits

The manage page provides:

- Search by kit name
- Search by description
- Search by barcode or kit number
- Search by kit ID using `KIT <id>`
- Sortable kit columns
- Pagination
- Selection
- Delete
- Barcode generation

Kit list fields include:

- Kit ID
- Barcode
- Name
- Item
- Cost
- Unit price
- Description

Selecting a kit opens the edit form.

## 14. Deleting Kits

To delete kits:

1. Select one or more kits in the manage table.
2. Choose **Delete**.
3. Confirm the deletion.

Deleting a kit:

- Deletes the kit header.
- Deletes component relationships.
- Does not delete its component item records.
- Does not remove historical sales or receiving lines already recorded.

If the kit cannot be deleted, OSPOS displays: **Item Kit(s) delete failed.**

## 15. Using Kits in Sales

Enter or scan a kit value in the Sales item field:

- A kit barcode
- A custom kit number
- A kit name selected by autocomplete
- `KIT <item_kit_id>` for the internal kit identifier

For example:

```text
KIT 12
```

The Sales process detects a valid kit and then:

1. Loads the kit header.
2. Loads the kit discount and price/print options.
3. Adds the optional parent kit item as a line.
4. Adds every component item.
5. Applies quantity and location.
6. Applies the kit discount.
7. Checks component stock availability.

### Sale behavior

Each component is added to the sale cart with:

- Component item ID
- Component quantity
- Selected stock location
- Applicable kit discount
- Kit price mode
- Kit price option
- Kit print option

The parent kit item and components may be merged into existing sale lines when they share an item and stock location.

## 16. Using Kits in Receivings

Item kits can also be entered in a Receiving.

When a kit is recognized:

1. OSPOS reads each kit component.
2. Component quantity is multiplied by the kit quantity.
3. Components are added to the receiving cart.
4. Stock is assigned to the receiving source location.

Example:

| Kit quantity | Component | Receiving quantity |
|---:|---|---:|
| 1 | Monitor | 1 |
| 1 | Keyboard | 1 |
| 1 | Mouse | 1 |

If the receiving mode is **Return**, OSPOS adjusts the quantity as a negative quantity.

## 17. Inventory Relationship

Kits do not maintain a single independent stock level.

Instead:

```text
Kit availability depends on component stock availability
```

For a kit containing:

- 1 monitor
- 1 keyboard
- 1 mouse

if only 3 monitors are available, the kit may be limited even if all other components have sufficient stock.

OSPOS can display a stock warning when a sale or receiving component is outside the configured available stock.

For accurate inventory management:

- Maintain all component item quantities
- Maintain the selected stock location
- Receive components before selling complete kits
- Ensure component `stock_type` is configured correctly

## 18. Module Permissions

Access to Item Kits is controlled through OSPOS employee permissions and module grants.

An employee normally needs access to the Item Kits module to:

- Open the kit list
- Create kits
- Update kits
- Delete kits
- Generate kit barcodes

Users should be granted only the permissions required for their role.

For sales and receiving use, the employee also needs the relevant:

- Sales module access
- Receiving module access
- Stock-location permission

Stock locations should be limited according to employee authorization.

## 19. Barcode Generation

From the Item Kits manage page:

1. Select one or more kits.
2. Choose **Generate Barcodes**.
3. OSPOS opens a barcode sheet for the selected kits.

Generated barcode values use:

```text
KIT <item_kit_id>
```

The barcode sheet contains:

- Kit name
- Barcode value
- Kit cost price
- Kit unit price

If the configured barcode format is not Code39 or Code128, OSPOS falls back to Code128 because string-based `KIT <id>` barcodes cannot be represented by some numeric-only formats.

## 20. Relationship with Other Modules

| Module | Relationship |
|---|---|
| Items | Provides component items and an optional parent kit item |
| Sales | Expands kits into sale cart lines |
| Receivings | Expands kits into receiving cart lines |
| Inventory | Tracks stock for component items |
| Customers | Sale discount context may interact with kit discounts |
| Taxes | Parent/component item tax configuration may apply |
| Reports | Sales and receiving reports show resulting transaction lines |
| Barcodes | Prints kit barcode sheets |
| Employees | Controls module and stock-location access |

## 21. Standard Kit Setup Example

### Example: Office Starter Kit

Create the kit with:

| Field | Value |
|---|---|
| Barcode | `OFFICE-STARTER` |
| Name | Office Starter Kit |
| Kit Item | Office Starter Kit parent item |
| Discount Type | Percentage |
| Discount | `5` |
| Price Option | Kit and Components |
| Print Option | All |

Components:

| Sequence | Component | Quantity |
|---:|---|---:|
| 1 | Notebook | 1 |
| 2 | Pen | 2 |
| 3 | Stapler | 1 |

When sold:

- OSPOS adds the parent kit item if assigned.
- OSPOS adds the notebook, two pens, and one stapler.
- The component and parent item prices follow the selected price option.
- A stock warning is generated if components are insufficient.
- The selected print option determines receipt display.

## 22. Example: Kit-Only Bundled Price

Configure:

| Setting | Value |
|---|---|
| Parent Kit Item | Required |
| Discount | Optional |
| Price Option | Kit Only |
| Print Option | Kit Only |

Sale behavior:

- The parent kit item carries the bundle price.
- Component item sale lines have zero price.
- The receipt can show only the parent kit item.

This is suitable for a bundle with a single selling price.

## 23. Example: Kit and Stock

Configure a bundle containing:

- 1 physical laptop
- 1 installation service item marked as no-stock

With **Kit and Stock**:

- The stocked laptop contributes to the calculated unit price.
- The no-stock service item does not contribute to or print a kit price.
- Other parent/kit behavior remains configured independently.

## 24. Best Practices

### Kit Design

- Keep kits small enough to remain understandable.
- Use unique and meaningful kit names.
- Assign all components explicitly.
- Avoid duplicate components in the kit.
- Use sequence values for predictable display order.
- Recalculate cost and unit prices after component price changes.

### Inventory

- Maintain accurate component quantities.
- Receive components, not only the kit container.
- Configure the correct stock location.
- Use stock warnings when selling packages.
- Do not assume one kit row represents physical stock.

### Pricing

- Decide whether customers will see component prices or only the package price.
- Use percentage discounts for percentage-based promotions.
- Use fixed discounts only when the fixed amount is intentional.
- Confirm that parent kit item prices match the expected package price.
- Review the unit-price calculation after component additions or removals.

### Receipts

- Use **Kit Only** for clean customer-facing bundle names.
- Use **All** for transparent itemization.
- Use **Priced Only** when free components should not appear.

### Data Maintenance

- Do not delete a component item that is still used by kits unless intentional.
- Use kit edit mode to replace components; avoid recreating kits unnecessarily.
- Retain old kits for historical reporting.
- Generate barcodes after the kit number is final.

## 25. Troubleshooting

### The kit does not appear in search

Check:

- The kit name or barcode spelling
- Whether the kit number was saved
- Whether `KIT <id>` is used correctly
- Whether the item-kit module is accessible to the employee

### The kit does not add in Sales or Receivings

Check:

- The entered value is a valid kit ID or kit number
- The component table contains components
- Component item IDs still exist
- Stock-location access is granted

### Component quantities are wrong

Check:

- The quantity saved for each component
- Kit quantity in the transaction
- Whether the mode is sale or return
- Whether the components are merged with existing cart lines

### Kit price is wrong

Check:

- Parent kit item unit price
- Component unit prices
- Price option
- Discount type
- Discount value
- `stock_type` on each component

### Stock warning appears

Check:

- Component quantity in the selected stock location
- Component reorder/availability settings
- Whether the kit quantity exceeds the component stock
- Whether the correct stock location was selected

### Deletion fails

Check database and application constraints:

- Confirm the selected IDs exist.
- Confirm database transactions complete successfully.
- Confirm component foreign keys and kit deletion operations are valid.
- Review the application log for database errors.

## 26. Database and Implementation Notes

The Item Kits implementation uses:

- `App\Controllers\Item_kits`
- `App\Models\Item_kit`
- `App\Models\Item_kit_items`
- `App\Libraries\Sale_lib`
- `App\Libraries\Receiving_lib`

The save operation:

- Uses `item_kit_id` as the kit primary key
- Uses `item_id` as a separate component or parent item reference
- Stores component quantities as decimal values
- Uses a transaction when replacing kit components

Kit barcode lookup recognizes:

- `KIT <item_kit_id>` syntax
- A custom `item_kit_number`

The kit module uses the state-changing HTTP actions:

- `postSave`
- `postDelete`
- `postCheckItemNumber`

The parent item suggestions and component item suggestions come from item search functions.

## 27. Recommended Workflow

1. Create or verify component items.
2. Verify component stock and locations.
3. Create the item kit.
4. Set an appropriate barcode or kit number.
5. Optionally assign a parent kit item.
6. Configure discount type and value.
7. Configure price and print options.
8. Add components and quantities.
9. Save and review calculated cost/unit prices.
10. Test the kit in a suspended sale or test environment.
11. Confirm stock movement and printed receipt lines.
12. Train cashiers on the kit barcode or `KIT <id>` syntax.

## 28. Quick Reference

```text
Kit identifier: KIT <item_kit_id>
Percentage discount: kit_discount_type = 0
Fixed discount: kit_discount_type = 1

Price options:
0 = Kit and Components
1 = Kit Only
2 = Kit and Stock

Print options:
0 = All
1 = Priced Only
2 = Kit Only

Stock availability:
Controlled by component item quantities

Cost calculation:
SUM(component cost price × component quantity)

Retail calculation:
Parent kit price + eligible component prices - kit discount
```
