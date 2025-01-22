FROM alpine:latest

# Install Samba
RUN apk add --no-cache \
    samba \
    samba-common-tools

# Create directories
RUN mkdir -p /shared && \
    mkdir -p /var/log/samba && \
    chmod 755 /var/log/samba

# Create smb.conf
RUN printf '%s\n' \
    '[global]' \
    'workgroup = WORKGROUP' \
    'server string = Samba Server' \
    'server role = standalone server' \
    'log file = /var/log/samba/log.%m' \
    'max log size = 50' \
    'dns proxy = no' \
    'map to guest = Bad User' \
    'security = user' \
    'disable netbios = yes' \
    '[shared]' \
    'path = /shared' \
    'browseable = yes' \
    'read only = no' \
    'guest ok = no' \
    'create mask = 0777' \
    'directory mask = 0777' \
    'valid users = ${SAMBA_USER}' \
    > /etc/samba/smb.conf

# Expose SMB port
EXPOSE 445/tcp

# Create user and start Samba
CMD adduser -S -H "${SAMBA_USER}" && \
    echo "${SAMBA_USER}:${SAMBA_PASSWORD}" | chpasswd && \
    (echo "${SAMBA_PASSWORD}"; echo "${SAMBA_PASSWORD}") | smbpasswd -a "${SAMBA_USER}" && \
    sed -i "s/\${SAMBA_USER}/${SAMBA_USER}/g" /etc/samba/smb.conf && \
    smbd --foreground --no-process-group
