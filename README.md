# qb-restaurant

A premium, highly-versatile player-owned shops script optimized for **QBCore**. 

## 🌟 Key Features
- **Multiple Inventory Support**: Choose between `ox_inventory` and `qb-inventory` via config.
- **Versatile Interaction**: Support for `ox_target`, `qb-target`, or native `ox_lib` points (TextUI).
- **Pure QBCore Integration**: Native logic for maximum performance and reliability.
- **Dynamic Pricing**: (OX Inventory only) Shop owners can stock items and set custom prices in real-time.
- **Management System**: Deposits all profits directly into the shop's society account (compatible with `qb-management`).
- **Boss Menu Support**: Integrated management access for each shop location.
- **Bilingual & Configurable**: Easy translations and settings for all locations, blips, and markers.

## 📋 Dependencies
- [qb-core](https://github.com/qbcore-framework/qb-core)
- [ox_lib](https://github.com/overextended/ox_lib)
- [qb-management](https://github.com/qbcore-framework/qb-management)
- **One of the following Inventories:**
  - [ox_inventory](https://github.com/overextended/ox_inventory) (Recommended for full features)
  - [qb-inventory](https://github.com/qbcore-framework/qb-inventory)
- **(Optional) Interaction System:**
  - [ox_target](https://github.com/overextended/ox_target)
  - [qb-target](https://github.com/qbcore-framework/qb-target)

## 🚀 Installation
1. Ensure all dependencies are started in your `server.cfg`.
2. Place the `qb-restaurant` folder into your `resources` directory.
3. Add `ensure qb-restaurant` to your `server.cfg`.
4. Configure your preferred **Inventory** and **Target** systems in `configuration/config.lua`.

## 🛠️ Configuration
Customization is handled within the `configuration/` directory:
- `config.lua`: Toggle Inventory/Target types, add shop locations, coords, and blips.
- `strings.lua`: Modify all labels, notifications, and target text.

---
**Author**: se9p
**Version**: 1.0.2
