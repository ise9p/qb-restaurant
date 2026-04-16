# qb-restaurant

A premium player-owned shops script designed specifically for **QBCore** and **OX Inventory**.

## 🌟 Features
- **Pure QBCore Integration**: Optimized to work natively with QBCore without unnecessary bridge files.
- **OX Inventory Power**: Leverages OX Inventory's UI, stashes, and shop functions for a seamless experience.
- **Dynamic Pricing**: Shop owners can stock items and set custom prices for each product in real-time.
- **Management System**: Automatically deposits all profits directly into the shop's society account.
- **Boss Menu Support**: Optional boss menu integration for each shop location.
- **Highly Configurable**: Custom blips, locations, and strings are easily adjustable.

## 📋 Dependencies
- [qb-core](https://github.com/qbcore-framework/qb-core)
- [ox_inventory](https://github.com/overextended/ox_inventory)
- [ox_lib](https://github.com/overextended/ox_lib)
- [qb-management](https://github.com/qbcore-framework/qb-management) (or equivalent boss menu system)

## 🚀 Installation
1. Ensure all dependencies are installed and updated.
2. Place the `qb-restaurant` folder into your server's `resources` directory.
3. Add `ensure qb-restaurant` to your `server.cfg`.
4. Configure your shops and locations in `configuration/config.lua`.

## 🛠️ Configuration
Check the `configuration/` directory to customize:
- `config.lua`: Shop locations, coordinates, blips, and boss menu settings.
- `strings.lua`: All text strings and translations.

---
**Author**: se9p
**Version**: 1.0.1
