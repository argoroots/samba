# Docker Samba Server

A lightweight Samba file sharing server running on Alpine Linux.

## Features

- Minimal Alpine-based image
- Single user authentication
- Modern SMB protocol (no legacy NetBIOS)
- Configurable via environment variables
- Simple setup and deployment

## Quick Start

1. Create project directory:
```bash
mkdir docker-samba
cd docker-samba
```

2. Create Dockerfile and docker-compose.yml with contents above

3. Create shared directory:
```bash
mkdir shared
```

4. Start the server:
```bash
docker-compose up -d
```

## Configuration

### Environment Variables

- `SAMBA_USER`: Username for Samba access (default: sambauser)
- `SAMBA_PASSWORD`: Password for Samba access (default: sambapass)

### Connection Details

Access the share at:
- Windows: `\\localhost\shared`
- Linux: `smb://localhost/shared`
- macOS: `smb://localhost/shared`

Replace `localhost` with your server's IP address when accessing remotely.

## Security Notes

1. Change default credentials
2. Use strong passwords
3. Avoid exposing to the internet
4. Set appropriate file permissions
5. Use firewall rules to restrict access

## Manual Build

```bash
# Build image
docker build -t samba-alpine .

# Run container
docker run -d \
  --name samba \
  -e SAMBA_USER=sambauser \
  -e SAMBA_PASSWORD=sambapass \
  -p 445:445/tcp \
  -v $(pwd)/shared:/shared \
  samba-alpine
```
