# Personal Magnet

A simple quality-of-life mod for Factorio that adds a reusable tool to collect items in a radius around the player.

## Features

* **Item Collection:** Instantly picks up all items dropped on the ground around you.

* **Belt Clearing:** Sucks up all items currently on conveyor belts within the radius.

* **Instant Mining:** Rapidly mines and collects all resources (like iron ore, copper, coal, and stone) from resource patches in the area.

## How to Use

1. Craft the **Personal Magnet** from your crafting menu.

2. Place the Personal Magnet in your hand or quickbar.

3. Right-click with the item in hand to activate its collection effect.

## Configuration

You can easily customize the mod's behavior by editing the top of the `control.lua` file inside the mod's `.zip` archive.

* `PICKUP_RADIUS`: Change the number to increase or decrease the collection radius (default is 15 tiles).

* `COLLECT_FROM_BELTS`: Set to `false` to stop the magnet from picking up items from conveyor belts.

* `MINE_RESOURCES`: Set to `false` to disable the instant-mining feature.

**Note:** The belt clearing and resource mining features are very powerful and may cause a brief moment of lag (a performance drop) when used in a very dense factory or on a massive ore patch. You can disable these features in the configuration if you prefer.
