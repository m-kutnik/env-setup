---
name: app-defaults-generator
description: >
  Analyze macOS app preferences and generate a configuration shell script.
  Use when the user wants to gather settings for an installed app, create a
  defaults script, reverse-engineer app configuration, or add a new app to
  the system-defaults directory. Also triggers on requests like "find config
  files for X app", "create a defaults script for X", or "what settings does
  X app have".
allowed-tools: bash read write edit grep find ls
---

# App Defaults Generator

Analyze a macOS application's preferences and generate a configuration shell script
that follows the project's existing `scripts/bash/system-defaults/` pattern.

## Workflow

### 1. Identify the app

The user provides either:

- An app name (e.g. "Ice", "Macs Fan Control")
- A bundle identifier (e.g. `com.jordanbaird.Ice`)

If given a name, find the bundle ID:

```bash
# Check /Applications for the app
ls /Applications/ | grep -i "<name>"

# Search defaults domains for a match
defaults domains 2>/dev/null | tr ',' '\n' | grep -i "<name>"
```

### 2. Gather all config files

Search these macOS config locations for anything related to the app:

```bash
# Primary preferences
defaults read <bundle-id>

# File-based config locations
find ~/Library/Preferences ~/Library/Application\ Support ~/Library/Containers \
     ~/Library/HTTPStorages ~/Library/Caches ~/Library/Saved\ Application\ State \
     ~/Library/WebKit -maxdepth 3 -path "*<bundle-id>*" 2>/dev/null
```

The `defaults read` output is the primary source. File-based locations help
understand if the app stores additional data (databases, caches, web data).

### 3. Analyze and categorize defaults

Read `references/noise-patterns.md` for a catalog of keys to skip. At a high level:

**Keep** (user-configurable behavior):

- Boolean toggles for features (enable/disable)
- Numeric settings (intervals, limits, percentages)
- Enum-style integers (mode selectors, style pickers)
- String preferences (custom paths, names)
- Update/sparkle settings (auto-update, check frequency)

**Skip** (noise / non-configurable):

- `NSWindow Frame *` — window position/size state
- `NSSplitView Subview Frames *` — split view layout state
- `NSColorPanel*`, `NSToolbar Configuration *` — system panel state
- `NSStatusItem Preferred Position *` — menu bar item positions (managed by app)
- `NSStatusItem Visible *` / `NSStatusItem VisibleCC *` — item visibility state
- `hasMigrated*` — version migration flags
- `SULastCheckTime`, `SUUpdateGroupIdentifier` — Sparkle internals
- `NSColorPanelMode` — color picker state
- Binary blob keys (`{length = N, bytes = 0x...}`) that aren't user-meaningful

**Special handling**:

- `Hotkeys` with `{length = 4, bytes = 0x6e756c6c}` — these are "null" (unset), skip them
- Large binary blobs (e.g. `IceIcon`, `MenuBarAppearanceConfigurationV2`) — note as
  "complex internal state, not scriptable via defaults write" and skip

### 4. Organize into logical groups

Group the remaining keys into categories. Use the app's UI/settings window
as a guide if visible. Common groupings:

- **Behavior** — core app behavior toggles
- **Appearance** — visual settings, icons, themes
- **Menu Bar** — menu bar specific settings (for menu bar apps)
- **Notifications** — alert and notification preferences
- **Updates** — Sparkle/auto-update settings
- **Launch** — startup/login behavior
- **Privacy** — data sharing, analytics

### 5. Generate the script

Follow the exact pattern from existing scripts in `scripts/bash/system-defaults/`.
Read one of the existing scripts for reference — `macs-fan-control.sh` or `aldente-pro.sh`.

The template:

```bash
#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname "$0")"
source "$SCRIPT_DIR/../_utils/helpers.sh"

log "Setting <AppName> defaults"
APP="<bundle-id>"

# <Category>
defaults_write_if_absent "$APP" <key> -<type> <value>
# ... more keys

success "<AppName> defaults set"
unset APP
```

Rules for the script:

- Use `defaults_write_if_absent` for every key (not raw `defaults write`)
- Use the correct type flag: `-int`, `-float`, `-string`, `-bool`, `-array`
- For boolean values, use `-int 1` / `-int 0` (matching the existing pattern)
- Mirror the user's current values as defaults
- Add blank lines between category sections
- Add a `# <Category>` comment before each group
- End with `success` message and `unset APP`
- Make the script executable: `chmod +x <path>`

### 6. Report to the user

Present a summary table showing:
| Category | Keys | Notes |

And any observations:

- Settings that might benefit from different defaults than current
- Settings that were skipped and why
- Any unusual findings

## Output location

Save the script to `scripts/bash/system-defaults/<app-name-kebab-case>.sh`

If the user hasn't specified an output location, default to the project's
`scripts/bash/system-defaults/` directory since that's where the existing
scripts live.
