#!/bin/bash
remote=111.111.111.111
port=22
pass=/opt/minecraft/.spass
RED='\033[0;31m'
BROWN='\033[0;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'
END='\e[m'
 

while true
do

local_check () {
if systemctl is-active --quiet minecraft.service; then
    echo "==================================="
    echo -e "${GREEN}Local Minecraft server is already running${NC}"
    echo "==================================="
elif  systemctl status minecraft | grep deactivating; then
    echo "==================================="
    echo -e "${RED}Local Minecraft server is shutting down...${NC}"
    echo "==================================="
elif systemctl status minecraft | grep failed; then
    sleep 20
    echo "==================================="
    echo -e "${GREEN}Starting local Minecraft server${NC}"
    echo "==================================="
    systemctl start minecraft.service
elif systemctl status minecraft | grep inactive; then
     echo "==================================="
     echo -e "${Green}Starting local Minecraft server${NC}"
     systemctl start minecraft.service
else
    sleep 10
fi
}

remote_check () {
   
if [ $? -ne 0 ]; then
    echo "==================================="
    echo -e "${RED}Remote Minecraft server is offline${NC}"
    echo "==================================="
    local_check
elif sshpass -f $pass ssh -q user@"$remote" systemctl is-active --quiet minecraft.service; then
    echo "==================================="
    echo -e "${GREEN}Remote Minecraft server is running${END}"
    echo -e "${BROWN}No local action taken${NC}"
    echo "==================================="
elif sshpass -f $pass ssh -q user@"$remote" systemctl status minecraft | grep deactivating; then
    echo "==================================="
    echo -e "${RED}Remote Minecraft server is shutting down...${NC}"
    echo "==================================="
elif sshpass -f $pass ssh -q user@"$remote" systemctl status minecraft | grep failed; then
    echo "==================================="
    echo -e "${RED}Remote Minecraft server is stopped${END}"
    echo -e "${BLUE}Checking local Minecraft server${NC}"
    echo "==================================="
    local_check
else
    local_check
fi
}

echo "==================================="
echo -e "${BLUE}Checking status of remote Minecraft server${NC}"
echo "==================================="
nmap "$remote" -p $port | grep open
remote_check

sleep 10
done
