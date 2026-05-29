#!/usr/bin/env bash

# This is a slightly overachieving test that ensures that when there's no
# index.html present in the directory docsify is supposed to serve from a proper
# fallback fake site is generated during start up and correctly served.

set -e

source dev-container-features-test-lib

CMD=$(cat <<EOF
curl --output /dev/null \
    --retry-connrefused --retry-delay 1 --retry 3 \
    --head --fail \
    http://localhost:3300/
EOF
)
check "serves at default port 3300" bash -c "${CMD}"

if command -v sudo >/dev/null 2>&1; then
    SUDO="sudo"
else
    SUDO=""
fi

install_browser_deps() {
    if command -v apt-get >/dev/null 2>&1; then
        echo "detected Debian/Ubuntu"

        sudo apt-get update
        wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo gpg --dearmor -o /usr/share/keyrings/googlechrome-linux-keyring.gpg
        echo "deb [arch=amd64 signed-by=/usr/share/keyrings/googlechrome-linux-keyring.gpg] https://dl-ssl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google.list
        sudo apt-get update
        DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC sudo apt-get install -y google-chrome-stable fonts-ipafont-gothic fonts-freefont-ttf libxss1 dbus dbus-x11 --no-install-recommends
        CHROMIUMPATH=/usr/bin/google-chrome-stable

    elif command -v dnf >/dev/null 2>&1; then
        echo "detected RHEL/Alma/Rocky/Fedora"

        $SUDO dnf install -y epel-release || true
        $SUDO dnf install -y chromium
        CHROMIUMPATH="$(command -v chromium-browser)"

    else
        echo "Unsupported distro"
        exit 1
    fi
}

install_browser_deps

echo "installing puppeteer..."
PUPPETEER_SKIP_DOWNLOAD=true npm install puppeteer --save

SCRIPT=$(cat <<EOF
import puppeteer from 'puppeteer';

const browser = await puppeteer.launch({
    headless: true,
    executablePath: '${CHROMIUMPATH}',
    args: [
        '--no-sandbox', 
        '--disable-setuid-sandbox',
        '--disable-dev-shm-usage',
    ],
});

const page = await browser.newPage();

try {
    // Navigate to the page
    await page.goto('http://localhost:3300', {
        waitUntil: 'load',
    });

    await page.waitForSelector('h1#fake-site', {
        visible: true,
        timeout: 10_000,
    })

    console.log('Puppeteer script executed successfully.');
} catch (error) {
    console.error('error running Puppeteer script:', error);
    process.exitCode = 1
} finally {
    await browser.close();
}

EOF
)
check "serves docsified page as HTML" bash -c "node -e \"${SCRIPT}\""

reportResults
