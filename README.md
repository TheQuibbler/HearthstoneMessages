# HearthstoneMessages

## Overview
HearthstoneMessages sends a random farewell line to your group chat when you begin casting a teleport-like spell, such as a Hearthstone-style return spell. It is meant to add flavor to party and raid play with quick, automatic send-off messages. The addon only announces your own casts and includes a short cooldown to prevent spam.

## Features
- Detects your player spellcast start event for teleport-like spell descriptions.
- Sends one random message from a curated list of themed lines.
- Chooses the correct group channel automatically:
- `RAID` when you are in a raid.
- `PARTY` when you are in a party.
- Does not send messages when you are not grouped.
- Includes a built-in announcement cooldown to avoid duplicate posts.

## Installation
1. Download or clone this repository.
2. Place the `HearthstoneMessages` folder into your WoW addons directory:
	`World of Warcraft/_retail_/Interface/AddOns/`
3. Start or restart World of Warcraft.
4. Run `/reload` in-game if the client is already running.
5. Verify that `HearthstoneMessages` is enabled on the character select AddOns list.

## Usage
- Join a party or raid.
- Cast a teleport-like spell (for example, a Hearthstone return spell).
- The addon posts one random farewell line to your active group chat channel.

## Modules
- `messages.lua`: Defines the `GoodbyeMessages` message pool.
- `core.lua`: Handles spellcast event detection, teleport description checks, cooldown gating, and chat announcement delivery.

## License
This project is licensed under GPL v3. See the [LICENSE](LICENSE) file for details.
