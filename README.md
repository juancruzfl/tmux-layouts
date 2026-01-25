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

Create a session with a canvas:
```bash
tmux new -s dev
```

Save current session layout:
```bash
# Press: prefix + Shift+S
# Or run: bash ~/.tmux/plugins/tmux-canvas/scripts/canvas-state.sh
```

## Troubleshooting

If canvases aren't loading:

1. Check hook is set:
```bash
tmux show-hooks -g | grep after-new-session
```

2. Verify permissions:
```bash
ls -la ~/.tmux/plugins/tmux-canvas/tmux-canvas.tmux
# Should show: -rwxr-xr-x
```

3. Check tmux messages for errors:
```bash
tmux show-messages
```

4. Manually test the init script:
```bash
bash -x ~/.tmux/plugins/tmux-canvas/scripts/session-init.sh dev
```
