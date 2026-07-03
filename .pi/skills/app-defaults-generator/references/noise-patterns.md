# Noise Patterns

Keys to skip when analyzing `defaults read` output. These are macOS framework
artifacts, window state, or internal bookkeeping — not user-configurable settings.

## macOS Framework Keys

These are managed by AppKit/UIKit and reflect transient UI state:

| Pattern                             | Description                              |
| ----------------------------------- | ---------------------------------------- |
| `NSWindow Frame *`                  | Window position and size (`x y w h ...`) |
| `NSSplitView Subview Frames *`      | Split view divider positions             |
| `NSColorPanel*`                     | Color picker panel state                 |
| `NSColorPanelMode`                  | Which color picker mode is active        |
| `NSToolbar Configuration *`         | Toolbar visibility/state                 |
| `NSStatusItem Preferred Position *` | Menu bar item ordering positions         |
| `NSStatusItem Visible *`            | Whether a status item is visible         |
| `NSStatusItem VisibleCC *`          | Control Center status item visibility    |

## Sparkle Update Framework

Apps using the Sparkle auto-update framework store these keys:

| Pattern                   | Description                        | Keep? |
| ------------------------- | ---------------------------------- | ----- |
| `SUAutomaticallyUpdate`   | Auto-install updates               | Yes   |
| `SUEnableAutomaticChecks` | Check for updates                  | Yes   |
| `SUSendProfileInfo`       | Send anonymous usage data          | Yes   |
| `SUHasLaunchedBefore`     | First-launch flag                  | No    |
| `SULastCheckTime`         | Timestamp of last update check     | No    |
| `SUUpdateGroupIdentifier` | A/B test group for staged rollouts | No    |

## Migration Flags

Apps sometimes store `hasMigrated<version>` keys after running data migrations.
Skip all of these — they're internal bookkeeping:

| Pattern                                   | Description                       |
| ----------------------------------------- | --------------------------------- |
| `hasMigrated*` (e.g. `hasMigrated0_10_0`) | Version migration completion flag |

## Binary Blobs

`defaults read` shows binary data as `{length = N, bytes = 0x...}`. Distinguish
between:

- **Small blobs (4 bytes, `0x6e756c6c`)** — This spells "null" in ASCII. The key
  is explicitly set to nil/empty. Skip these.
- **Large blobs** — Could be archived objects (NSKeyedArchiver), plists, or JSON
  data stored as NSData. Note these as "complex internal state" and skip — they
  can't be meaningfully set via `defaults write`.

## Other Noise

| Pattern                          | Description                           |
| -------------------------------- | ------------------------------------- |
| `AppleLanguages` / `AppleLocale` | System locale, not app-specific       |
| `AppleAntiAliasingThreshold`     | System rendering preference           |
| `NSNavLastRootDirectory`         | Last-opened directory in file dialogs |
| `NSRecentDocumentRecords`        | Recent files list                     |
