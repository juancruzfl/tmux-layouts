# tmux-canvas

A tmux plugin for managing session layouts as reusable canvases.

## Installation

### Using TPM (Tmux Plugin Manager) - Recommended

1. Add to your `~/.tmux.conf`:
```bash
set -g @plugin 'juancruzfl/tmux-canvas'
```

2. Press `prefix + I` to install

3. Reload tmux config:
```bash
tmux source-file ~/.tmux.conf
```

### Manual Installation

1. Clone the repository:
```bash
git clone https://github.com/juancruzfl/tmux-canvas ~/.tmux/plugins/tmux-canvas
```

2. Add to your `~/.tmux.conf`:
```bash
run-shell ~/.tmux/plugins/tmux-canvas/tmux-canvas.tmux
```

3. Reload tmux config:
```bash
tmux source-file ~/.tmux.conf
```

## Verify Installation

Check that the hook is registered:
```bash
tmux show-hooks -g | grep after-new-session
```

Should output:
```
after-new-session  run-shell '/path/to/tmux-canvas/scripts/session-init.sh #{session_name}'
```

## Usage

### Creating Sessions with Canvases

Create a session with a canvas:
```bash
tmux new -s dev
```

The plugin will:
- Look for a predefined canvas at `~/.tmux/plugins/tmux-canvas/canvases/dev.sh`
- Or look for a saved canvas at `~/.tmux-canvases/dev.sh`
- Or create a new default canvas if neither exists

### Saving Your Current Layout

Save your current session layout as a canvas:
```bash
# Press: prefix + Shift+S (hold Shift and press S)
```

**Note:** Lowercase `s` (`prefix + s`) is tmux's built-in session tree viewer and is NOT used by this plugin.

Your canvas will be saved to `~/.tmux-canvases/<session-name>.sh`

### Custom Keybindings

Customize the save keybinding in your `~/.tmux.conf`:
```bash
# Use a different key
unbind S
bind-key C run-shell "bash ~/.tmux/plugins/tmux-canvas/scripts/canvas-state.sh"

# Or use without prefix (just Ctrl+s)
bind-key -n C-s run-shell "bash ~/.tmux/plugins/tmux-canvas/scripts/canvas-state.sh"
```

## Creating Custom Canvases

Create predefined canvases in `~/.tmux/plugins/tmux-canvas/canvases/`:
```bash
#!/usr/bin/env bash
# Canvas: dev
# Development environment

# Window 1: Code editor
tmux rename-window -t "$SESSION_NAME:0" "editor"
tmux send-keys -t "$SESSION_NAME:0" "nvim ." C-m

tmux split-window -t "$SESSION_NAME:0" -h -p 30
tmux send-keys -t "$SESSION_NAME:0.1" "git status" C-m

# Window 2: Servers
tmux new-window -t "$SESSION_NAME" -n "servers"
tmux send-keys -t "$SESSION_NAME:servers" "npm run dev" C-m

# Return to editor
tmux select-window -t "$SESSION_NAME:0"
```

Save this as `~/.tmux/plugins/tmux-canvas/canvases/dev.sh` and make it executable:
```bash
chmod +x ~/.tmux/plugins/tmux-canvas/canvases/dev.sh
```

Now `tmux new -s dev` will automatically load this layout!

## Development

### Setting Up a Test Environment

To test the plugin without affecting your main tmux configuration, use the included sandbox environment:

1. Clone the repository:
```bash
git clone https://github.com/juancruzfl/tmux-canvas ~/Projects/tmux-canvas
cd ~/Projects/tmux-canvas
```

2. Start a sandbox tmux session:
```bash
tmux -L sandbox -f test/test.conf new-session -s "plugin-test"
```

The `-L sandbox` flag creates an isolated tmux server that won't interfere with your main tmux sessions.

### Test Configuration Features

The `test/test.conf` file provides:

- **Visual indicators**: Yellow status bar shows you're in TEST MODE
- **Debug keybindings**:
  - `prefix + H` - Show registered hooks
  - `prefix + M` - Show tmux messages
  - `prefix + D` - Show debug log
  - `prefix + r` - Reload test config
- **Quick test layouts**:
  - `prefix + 1` - Create simple 2-pane layout
  - `prefix + 2` - Create 3-pane layout
  - `prefix + 3` - Create 4-pane layout

### Manual Testing Workflow
```bash
# 1. Start sandbox session
tmux -L sandbox -f test/test.conf new-session -s "my-test"

# 2. Inside the session:
#    - Press prefix + 1 to create a test layout
#    - Press prefix + Shift+S to save the canvas
#    - Press prefix + L to list saved canvases
#    - Press prefix + H to verify hooks

# 3. Test canvas restoration
#    - Exit the session (type 'exit' or press Ctrl+d)
#    - Recreate it: tmux -L sandbox -f test/test.conf new-session -s "my-test"
#    - Your layout should be restored!

# 4. Clean up when done
tmux -L sandbox kill-server
rm -rf ~/.tmux-canvases-test
```

### Testing Different Canvases

The test environment includes example canvases in `canvases/`:
```bash
# Test the dev canvas
tmux -L sandbox -f test/test.conf new-session -s "dev"

# Test the simple canvas
tmux -L sandbox -f test/test.conf new-session -s "simple"
```

### File Structure
```
tmux-canvas/
├── README.md
├── LICENSE
├── tmux-canvas.tmux          # Main plugin file
├── scripts/
│   ├── session-init.sh       # Loads canvases on session creation
│   ├── create-canvas.sh      # Creates new canvas templates
│   └── canvas-state.sh       # Saves current session as canvas
├── canvases/
│   ├── dev.sh                # Example development canvas
└── test/
    ├── test.conf             # Sandbox tmux configuration
    └── test_find_canvases.sh          # Tests for finding canvses
```

## Troubleshooting

### Canvases aren't loading

1. Check hook is set:
```bash
tmux show-hooks -g | grep after-new-session
```

2. Verify permissions:
```bash
ls -la ~/.tmux/plugins/tmux-canvas/tmux-canvas.tmux
# Should show: -rwxr-xr-x (executable)
```

3. Check tmux messages for errors:
```bash
tmux show-messages
```

4. Manually test the init script:
```bash
bash -x ~/.tmux/plugins/tmux-canvas/scripts/session-init.sh dev
```

### Canvas save returns error 127

This means the script file can't be found. Check:
```bash
# Verify the file exists and is executable
ls -la ~/.tmux/plugins/tmux-canvas/scripts/canvas-state.sh

# Make it executable if needed
chmod +x ~/.tmux/plugins/tmux-canvas/scripts/canvas-state.sh
```

### Wrong keybinding triggered

If pressing `prefix + s` shows the session tree instead of saving:
- You're using lowercase `s` instead of `Shift+S`
- Press `prefix` then hold `Shift` and press `S`

### Test environment conflicts with main tmux

The test environment uses `-L sandbox` to create a separate tmux server. If you're having issues:
```bash
# Kill the sandbox server
tmux -L sandbox kill-server

# Your main tmux sessions are unaffected
tmux ls  # Shows your normal sessions
```

## Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Test your changes using the sandbox environment:
```bash
   tmux -L sandbox -f test/test.conf new-session -s "test-feature"
```
4. Run the test suite:
```bash
   ./test/run-tests.sh
```
5. Submit a pull request
