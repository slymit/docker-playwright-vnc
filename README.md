# Playwright with VNC: Headed Browser Docker Images

Official Playwright images from Microsoft are excellent for CI/CD pipelines and pure headless execution. However, they lack a graphical user interface.

This project solves that problem by providing a lightweight, VNC-enabled environment.

These images are built from the ground up on a slim Debian base (node:22-bookworm-slim) to be as optimized as possible while still providing a full graphical environment.

This project is a fork of the [RedHatQE/playwright-images](https://github.com/RedHatQE/playwright-images) repository with several key improvements:

- Replaced Xvnc with x11vnc;
- Added native noVNC support;
- Integrated [Patchright](https://github.com/Kaliiiiiiiiii-Vinyzu/patchright) for Chromium-based browsers.

## Key Features
- VNC Server Built-in: Connect with any VNC client to view and interact with the browser.
- Headed Mode by Default: Designed specifically for running browsers with their UI visible.
- Multiple Browser Variants: Build tailored images for Firefox, Chromium, or Google Chrome.
- All-in-One Image: An all variant includes all three browsers for maximum flexibility.
- Optimized for Size: Multi-stage Dockerfile and careful package selection to keep images lean.
- Configurable: Control the browser type and headless mode at runtime with environment variables.
- Single Source: Manage all image variants from a single, easy-to-maintain Dockerfile.multibuild.

## 🎭 Latest Release

See [Docker Hub](https://hub.docker.com/r/slymit/playwright-vnc/tags)

### 🐳 Available Images
- `slymit/playwright-vnc:latest` (all browsers)
- `slymit/playwright-vnc:firefox`
- `slymit/playwright-vnc:chromium`
- `slymit/playwright-vnc:chrome`

### 📦 Version-Specific Tags
- `slymit/playwright-vnc:1.0.0`
- `slymit/playwright-vnc:1.0.0-firefox`
- `slymit/playwright-vnc:1.0.0-chromium`
- `slymit/playwright-vnc:1.0.0-chrome`

### 🚀 Quick Start
```bash
# Run with all browsers available
docker run -p 5900:5900 -p 6900:6900 -p 3000:3000 slymit/playwright-vnc:latest

# Connect via VNC
vncviewer localhost:5900
```

Connect via noVNC: http://localhost:6900/

## How to Build the Images (Local Development)

```bash
# Build latest Playwright version (all browsers)
./build.sh

# Build specific Playwright version
./build.sh --playwright-version 1.55.0

# Build only specific browser variants  
./build.sh firefox chrome

# Customize repository name for local builds
./build.sh --repo "localhost/playwright-vnc"
```

### Available Image Variants

| Image Tag | Default Browser | Installed Browsers |
| :--- | :--- | :--- |
| `:latest` | Chromium | All browsers (Firefox, Chromium, Chrome) |
| `:firefox` | Firefox | Playwright's Firefox |
| `:chromium`| Chromium | Playwright's Chromium |
| `:chrome` | Google Chrome | Google Chrome (Stable) |


## How to Run the Images

Use docker/podman to start a container. Map VNC port (5900) and Playwright server port (3000).

```bash
# Run specific browser image
docker run -p 5900:5900 -p 3000:3000 slymit/playwright-vnc:firefox

# Run all-browsers image with specific browser selection
docker run -e PW_BROWSER="chrome" -p 5900:5900 -p 3000:3000 slymit/playwright-vnc:latest

# Run in headless mode  
docker run -e PW_HEADLESS="true" -p 3000:3000 slymit/playwright-vnc:latest
```

### Environment Variables
- `PW_BROWSER`: Specify browser (`firefox`, `chromium`, `chrome`) 
- `PW_HEADLESS`: Run in headless mode (`true`/`false`, default: `false`)
- `PW_ARGS`: Specify browser arguments (use space as a separator, default: `<not set>`)
- `USE_PATCHRIGHT`: Use Patchright instead of Playwright for Chromium-based browsers (`true`/`false`, default: `false`)
- `VNC_PASSWORD`: Password for VNC and noVNC (default: `password`)

### Connecting with a VNC Client
VNC will run at 5900 port. You can connect your favorite VNC client.
```
vncviewer localhost:5900 
```

noVNC will run on port 6900 at http://localhost:6900/

## Connecting with a Playwright Client
- Connecting to a Chromium or Google Chrome Server
    ```python
    # client.py
    from playwright.sync_api import sync_playwright

    with sync_playwright() as p:
        browser = p.chromium.connect("ws://localhost:3000/playwright")
        print("Connected to Chromium!")
        page = browser.new_page()
        page.goto("https://playwright.dev/")
        print(page.title())
        browser.close()
    ```
- Connecting to a Firefox Server:
    ```python
    # client.py
    from playwright.sync_api import sync_playwright

    with sync_playwright() as p:
        browser = p.firefox.connect("ws://localhost:3000/playwright")
        print("Connected to Firefox!")
        page = browser.new_page()
        page.goto("https://playwright.dev/")
        print(page.title())
        browser.close()
    ```