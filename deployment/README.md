# Guide to install Webhook

## SSH into your EC2 Instance:

```
ssh -i /path/to/your/key.pem ubuntu@your_ec2_public_ip
```

Identify Latest Version & Architecture:
 - Go to the adnanh/webhook GitHub Releases page: [webhook](https://github.com/adnanh/webhook)
 - Find the latest stable release version number
 - Determine your EC2 instance's architecture

(ARM-based) are arm64. You can check with:
    ```
    dpkg --print-architecture #
    ```
    
    or
    
    ```
    uname -m
    ```

Download the Correct Binary:

```
# --- Example for version 2.8.0 and amd64 architecture ---
VERSION="2.8.0"
ARCH="amd64" # Or change to "arm64" if needed
cd /tmp
wget "https://github.com/adnanh/webhook/releases/download/${VERSION}/webhook-linux-${ARCH}.tar.gz"
```
## If wget is not installed: `sudo apt update && sudo apt install wget -y`

Extract the Binary:

```
tar -xvzf webhook-linux-${ARCH}.tar.gz
```
 
 - This will extract the contents into a folder, usually named webhook-linux-<arch>.

M## ove the Binary to a Location in your PATH:
This makes the webhook command available system-wide. /usr/local/bin is a standard place for manually installed software.

# Navigate into the extracted directory

```
cd webhook-linux-${ARCH}/
```

## Move the webhook binary
```
sudo mv webhook /usr/local/bin/webhook
```

### Set Permissions:
 
 - Ensure the binary is executable.

```
sudo chmod +x /usr/local/bin/webhook
```

### Verify Installation:

 - Check if the command works and display its version

```
webhook -version
```

 - You should see output like webhook version <version>

## Clean Up:

 - Remove the downloaded archive and extracted folder

   ```
    cd /tmp
    rm webhook-linux-${ARCH}.tar.gz
    rm -r webhook-linux-${ARCH}/ # Be careful with rm -r! Double-check directory name.
   ```

   
