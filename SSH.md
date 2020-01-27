
# Example SSHFS:
ssh -p $(docker port gearbox-base-alpine-3.3.0-shell 22/tcp | awk -F: '{print$2}') gearbox@localhost

mkdir -p /projects/default
sshfs -C -o StrictHostKeyChecking=no mick@10.0.5.57:/Users/mick/Sites/default /projects/default

