# Zellij — Complete Reference Guide

> Version: 0.43.1 | Preset: Default | Config: `~/.config/zellij/config.kdl`

---

## Table of Contents
1. [Core Concepts](#core-concepts)
2. [How the Modal System Works](#how-the-modal-system-works)
3. [All Modes & Keybindings](#all-modes--keybindings)
4. [Common Workflows](#common-workflows)
5. [Copy & Paste](#copy--paste)
6. [Sessions](#sessions)
7. [Layouts](#layouts)
8. [Configuration Reference](#configuration-reference)
9. [Tips & Tricks](#tips--tricks)

---

## Core Concepts

Zellij has three levels of organization:

```
Session
 └── Tabs (like browser tabs)
      └── Panes (split windows inside a tab)
```

- **Session** — a named workspace that persists even after you close the terminal. You can detach and reattach.
- **Tab** — a full-screen workspace inside a session. You can have multiple tabs.
- **Pane** — a split region inside a tab. Can be tiled (fixed) or floating.

---

## How the Modal System Works

Zellij uses **modes**. You're always in one mode at a time.

```
Normal (default)
  ├── Ctrl+P → Pane mode
  ├── Ctrl+T → Tab mode
  ├── Ctrl+N → Resize mode
  ├── Ctrl+S → Scroll mode
  ├── Ctrl+o → Session mode
  ├── Ctrl+H → Move mode
  └── Ctrl+G → Locked mode (disables all Zellij shortcuts)
```

- **Enter a mode** → press the shortcut from Normal mode
- **Exit any mode** → press `Esc` or `Enter` to return to Normal
- The **status bar** at the bottom always shows your current mode and available keys

> Think of it like Vim — you're always in a mode, and `Esc` gets you back to Normal.

---

## All Modes & Keybindings

### Normal Mode (default)
Quick actions without entering a sub-mode:

| Key | Action |
|-----|--------|
| `Alt+N` | New pane (auto-split) |
| `Alt+←/→/↑/↓` | Move focus between panes |
| `Alt+H/L/J/K` | Move focus between panes (vim-style) |
| `Alt+[` | Previous tab |
| `Alt+]` | Next tab |
| `Alt++` | Increase pane size |
| `Alt+-` | Decrease pane size |
| `Ctrl+G` | Toggle locked mode |

---

### Pane Mode → `Ctrl+P`
Everything about creating, closing, and navigating panes.

| Key | Action |
|-----|--------|
| `N` | New pane (auto-direction) |
| `D` | New pane **down** (horizontal split) |
| `R` | New pane **right** (vertical split) |
| `X` | Close focused pane |
| `F` | Toggle **fullscreen** for focused pane |
| `Z` | Toggle **pane frames** (borders) |
| `W` | Toggle **floating** pane |
| `E` | Embed floating pane (make it tiled) |
| `H/←` | Move focus left |
| `L/→` | Move focus right |
| `J/↓` | Move focus down |
| `K/↑` | Move focus up |
| `P` | Switch focus (cycle through panes) |
| `Esc` | Back to Normal |

---

### Tab Mode → `Ctrl+T`
Everything about tabs.

| Key | Action |
|-----|--------|
| `N` | New tab |
| `X` | Close tab |
| `R` | Rename tab |
| `H/←` | Previous tab |
| `L/→` | Next tab |
| `1`–`9` | Jump to tab N |
| `S` | Sync mode (send input to all panes in tab) |
| `B` | Break pane into new tab |
| `Esc` | Back to Normal |

---

### Scroll Mode → `Ctrl+S`
Scroll through pane history without a mouse.

| Key | Action |
|-----|--------|
| `J/↓` | Scroll down one line |
| `K/↑` | Scroll up one line |
| `Ctrl+F` | Page down |
| `Ctrl+B` | Page up |
| `G` | Scroll to bottom |
| `Ctrl+G` | Scroll to top |
| `E` | Open scrollback in `$EDITOR` |
| `S` | Enter **Search mode** (see below) |
| `Esc` | Exit scroll, back to Normal |

**Search mode** (triggered by `S` inside Scroll mode):

| Key | Action |
|-----|--------|
| Type | Search term |
| `Enter` | Confirm search |
| `N` | Next match |
| `P` | Previous match |
| `C` | Toggle case sensitivity |
| `W` | Toggle whole-word match |
| `O` | Toggle wrap-around |
| `Esc` | Back to Scroll mode |

---

### Resize Mode → `Ctrl+N`
Resize the focused pane.

| Key | Action |
|-----|--------|
| `H/←` | Shrink left |
| `L/→` | Shrink right |
| `J/↓` | Shrink down |
| `K/↑` | Shrink up |
| `+` | Increase size |
| `-` | Decrease size |
| `Esc` | Back to Normal |

---

### Move Mode → `Ctrl+H`
Move the focused pane to a different position.

| Key | Action |
|-----|--------|
| `H/←` | Move pane left |
| `L/→` | Move pane right |
| `J/↓` | Move pane down |
| `K/↑` | Move pane up |
| `N` | Move to next position |
| `Esc` | Back to Normal |

---

### Session Mode → `Ctrl+o`
Manage sessions.

| Key | Action |
|-----|--------|
| `D` | **Detach** from session (session keeps running) |
| `W` | Open **session manager** (switch/create sessions) |
| `C` | Open **configuration** screen |
| `Esc` | Back to Normal |

---

### Locked Mode → `Ctrl+G`
Disables ALL Zellij keybindings. Useful when running an app (e.g. vim, another multiplexer) that has conflicting shortcuts.

| Key | Action |
|-----|--------|
| `Ctrl+G` | Exit locked mode, back to Normal |

---

## Common Workflows

### Split screen for coding
```
1. Ctrl+P → D        (split bottom — run server/tests)
2. Ctrl+P → R        (split right — file browser or logs)
3. Alt+←/→           (switch between panes quickly)
```

### Open a floating terminal
```
Ctrl+P → W           (toggle floating pane — great for quick commands)
Ctrl+P → W           (toggle back to hide it)
```

### Rename a tab for a project
```
Ctrl+T → R → type name → Enter
```

### Full-screen focus on one pane
```
Ctrl+P → F           (toggle fullscreen on focused pane)
Ctrl+P → F           (toggle back)
```

### Open multiple projects in one session
```
Ctrl+T → N           (new tab for project 2)
Ctrl+T → R           (rename it)
Alt+[ / Alt+]         (switch between projects)
```

### Save session and come back later
```
Ctrl+o → D           (detach — session keeps running in background)
zellij attach         (reattach from any terminal — all panes restored)
```

---

## Copy & Paste

Your setup uses `pbcopy` (macOS clipboard) with `copy_on_select=true`.

| Action | How |
|--------|-----|
| **Copy** | Click and drag to select text → auto-copied to clipboard |
| **Paste** | `Cmd+V` (Alacritty handles this) |
| **Copy in scroll mode** | Enter Scroll mode (`Ctrl+S`), then select with mouse or keyboard |
| **Keyboard selection** | Scroll mode → `Space` to start selection → move with `H/J/K/L` → `Y` to yank |

---

## Sessions

Sessions persist after terminal closes. This is Zellij's killer feature.

```bash
# Start a named session
zellij --session myproject

# List all sessions
zellij list-sessions

# Attach to a session
zellij attach myproject

# Attach to most recent session (what Alacritty does on launch)
zellij attach --create

# Kill a specific session
zellij kill-session myproject

# Kill all sessions
zellij kill-all-sessions
```

**From inside Zellij:**
- `Ctrl+o → W` → opens visual session manager to switch sessions
- `Ctrl+o → D` → detach (session stays alive)

---

## Layouts

Layouts let you define a pre-built workspace in a KDL file.

```bash
# Launch with compact layout (what you have set as default)
zellij --layout compact

# Launch with default layout
zellij --layout default
```

**Example custom layout** (`~/.config/zellij/layouts/dev.kdl`):
```kdl
layout {
    pane split_direction="vertical" {
        pane size="60%" name="editor"
        pane split_direction="horizontal" {
            pane size="70%" name="server"
            pane name="tests"
        }
    }
}
```
Launch with: `zellij --layout dev`

---

## Configuration Reference

**File:** `~/.config/zellij/config.kdl`

| Setting | Your Value | What it does |
|---------|-----------|--------------|
| `theme` | `catppuccin-mocha` | Color theme |
| `default_layout` | `compact` | No pane borders, cleaner look |
| `mouse_mode` | `true` | Click to focus, scroll with wheel |
| `copy_command` | `pbcopy` | Copy to macOS clipboard |
| `copy_on_select` | `true` (default) | Auto-copy on mouse select |
| `scroll_buffer_size` | `10000` (default) | Lines of scrollback per pane |

**Reload config:** Changes apply live — no restart needed for most settings.

---

## Tips & Tricks

### 1. Floating pane for quick commands
`Ctrl+P → W` opens a floating pane you can use for a quick command, then hide it. Much faster than switching tabs.

### 2. Sync mode for multi-server commands
`Ctrl+T → S` sends your keystrokes to ALL panes in the current tab simultaneously. Useful for running the same command on multiple servers.

### 3. Break a pane into its own tab
`Ctrl+T → B` takes the focused pane and makes it its own tab. Great when a pane gets too important to stay as a split.

### 4. Rename tabs to stay organized
Always rename tabs with `Ctrl+T → R`. E.g. `api`, `frontend`, `db`, `logs`.

### 5. Use layouts for repeatable setups
Save your ideal split layout to `~/.config/zellij/layouts/` and launch it by name. Never manually re-split windows again.

### 6. Locked mode when using Vim or Helix
If your editor shortcuts conflict with Zellij, press `Ctrl+G` to enter locked mode. All Zellij bindings are disabled until you press `Ctrl+G` again.

### 7. Search through scrollback
`Ctrl+S → S` → type to search through your pane's history. Faster than scrolling manually.

### 8. Edit scrollback in your editor
`Ctrl+S → E` dumps the entire scrollback into `$EDITOR`. Useful for searching or copying large command outputs.

---

## Quick Reference Card

```
PANE            Ctrl+P → ...        TAB             Ctrl+T → ...
───────────────────────────         ───────────────────────────
N  new pane                         N  new tab
D  split down                       X  close tab
R  split right                      R  rename tab
X  close pane                       H/L  prev/next tab
F  fullscreen                       1-9  jump to tab
W  float/unfloat                    S  sync all panes
Z  toggle borders                   B  break pane to tab

SCROLL          Ctrl+S → ...        SESSION         Ctrl+o → ...
───────────────────────────         ───────────────────────────
K/J  up/down                        D  detach
Ctrl+B/F  page up/down              W  session manager
G  bottom  Ctrl+G  top              C  config screen
S  search
E  open in editor

RESIZE          Ctrl+N              MOVE            Ctrl+H
FOCUS           Alt+arrows          LOCK            Ctrl+G
```

---

*Sources: [Zellij Docs](https://zellij.dev/documentation/) | [Keybinding Presets](https://zellij.dev/documentation/keybinding-presets.html) | [Configuration](https://zellij.dev/documentation/configuration)*
