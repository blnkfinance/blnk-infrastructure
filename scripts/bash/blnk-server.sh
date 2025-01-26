################################################################################################################################################
## This is a Bash script used for setting up and deploying blnk-finance server service for the Blnk project. It performs the following tasks:
## 1. Sets up environment variables for Redis, PostgreSQL, SSL email, Slack webhook, and Blnk version.
## 2. Detects the operating system to determine the appropriate Docker installation commands.
## 3. Checks if Docker is installed and installs it if necessary.
## 4. Ensures the configuration directory exists.
## 5. Creates a JSON configuration file with the provided environment variables.
## 6. Deploys the worker service using Docker, creating a Docker network and running a Docker container with the specified configuration.
################################################################################################################################################
#!/bin/bash

# Variables (these are replaced during templatefile rendering)
redis_host="${redis_host}"
postgress_host="${postgress_host}"
ssl_email="${ssl_email}"
slack_webhook="${slack_webhook}"
blnk_version="${blnk_version}"

# Determine the operating system
detect_os() {
  if [ -f /etc/os-release ]; then
    . /etc/os-release
    echo "$ID"
  else
    echo "unknown"
  fi
}

OS=$(detect_os)

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
  echo "Docker is not installed. Installing Docker now..."
  case "$OS" in
    ubuntu|debian)
      sudo apt-get update && sudo apt-get install -y docker.io
      ;;
    centos|rhel|fedora)
      sudo yum install -y yum-utils
      sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
      sudo yum install -y docker-ce docker-ce-cli containerd.io
      ;;
    amzn)
      sudo amazon-linux-extras enable docker
      sudo yum install -y docker
      ;;
    *)
      echo "Unsupported OS. Please install Docker manually."
      exit 1
      ;;
  esac
  sudo systemctl start docker
  sudo systemctl enable docker
  echo "Docker installed successfully."
fi

# Ensure the config directory exists
CONFIG_DIR="/opt/blnk/config"
if [ ! -d "$CONFIG_DIR" ]; then
  mkdir -p "$CONFIG_DIR"
  echo "Created directory: $CONFIG_DIR"
fi

cat <<EOF > /opt/blnk/config/blnk.json
{
  "project_name": "Blnk",
  "data_source": {
    "dns": "${postgress_host}"
  },
  "redis": {
    "dns": "${redis_host}"
  },
  "server": {
    "domain": "blnk.io",
    "ssl": false,
    "ssl_email": "${ssl_email}",
    "port": "5001"
  },
  "notification": {
    "slack": {
      "webhook_url": "${slack_webhook}"
    }
  }
}
EOF

# Deploy using Docker
docker network create blnk-network || true

docker run -d --name server --network blnk-network \
  -p 5001:5001 -p 80:80 -p 443:443 \
  -e OTEL_EXPORTER_OTLP_ENDPOINT=http://jaeger:4318 \
  -v /opt/blnk/config/blnk.json:/blnk.json \
  jerryenebeli/blnk:${blnk_version} /bin/sh -c "blnk migrate up && blnk start"
