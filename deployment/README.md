SSH into your EC2 Instance:
Bash

ssh -i /path/to/your/key.pem ubuntu@your_ec2_public_ip

Identify Latest Version & Architecture:

    Go to the adnanh/webhook GitHub Releases page: https://github.com/adnanh/webhook/releases
    Find the latest stable release version number (e.g., 2.8.0). Note this down.
    Determine your EC2 instance's architecture. Most modern EC2 instances are amd64 (also known as x86_64). Graviton instances (ARM-based) are arm64. You can check with:
    Bash

    dpkg --print-architecture
    # or
    uname -m

Download the Correct Binary:

    Replace <version> with the version number you found (e.g., 2.8.0).
    Replace <arch> with your architecture (amd64 or arm64).
    Use wget or curl to download the archive to a temporary location like /tmp.

Bash

# --- Example for version 2.8.0 and amd64 architecture ---
VERSION="2.8.0"
ARCH="amd64" # Or change to "arm64" if needed
cd /tmp
wget "https://github.com/adnanh/webhook/releases/download/${VERSION}/webhook-linux-${ARCH}.tar.gz"

    (If wget isn't installed: sudo apt update && sudo apt install wget -y)

Extract the Binary:
Bash

tar -xvzf webhook-linux-${ARCH}.tar.gz

This will extract the contents into a folder, usually named webhook-linux-<arch>.

Move the Binary to a Location in your PATH:
This makes the webhook command available system-wide. /usr/local/bin is a standard place for manually installed software.
Bash

# Navigate into the extracted directory (name might vary slightly)
cd webhook-linux-${ARCH}/

# Move the webhook binary
sudo mv webhook /usr/local/bin/webhook

Set Permissions:
Ensure the binary is executable.
Bash

sudo chmod +x /usr/local/bin/webhook

Verify Installation:
Check if the command works and display its version.
Bash

webhook -version

You should see output like webhook version <version>.

Clean Up:
Remove the downloaded archive and extracted folder.
Bash

    cd /tmp
    rm webhook-linux-${ARCH}.tar.gz
    rm -r webhook-linux-${ARCH}/ # Be careful with rm -r! Double-check directory name.
