#Update Masternode Script by mrx0rhk
#This Script updates the bitwin24 Masternode to the newest Version


declare -r COIN_NAME='bitwin24'
declare -r COIN_DAEMON="${COIN_NAME}d"
declare -r COIN_CLI="${COIN_NAME}-cli"
declare -r COIN_PATH='/usr/local/bin'
declare -r BOOTSTRAP_LINK='https://www.dropbox.com/s/mg606h8lqgwqk5m/bootstrap.zip'
declare -r COIN_ARH='http://167.172.160.11/0.0.9/bitwin24-0.0.9-x86_64-linux-gnu.tar.gz'
declare -r COIN_TGZ=$(echo ${COIN_ARH} | awk -F'/' '{print $NF}')
declare -r CONFIG_FILE="${COIN_NAME}.conf"
declare -r CONFIG_FOLDER="${HOME}/.${COIN_NAME}"

#Color codes
RED='\033[0;91m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

#TCP port
PORT=24072
RPC=24071

#Clear keyboard input buffer
function clear_stdin { while read -r -t 0; do read -r; done; }

#Delay script execution for N seconds
function delay { echo -e "${GREEN}Sleep for $1 seconds...${NC}"; sleep "$1"; }

#Stop daemon if it's already running
function stop_daemon {
    if pgrep -x 'bitwin24d' > /dev/null; then
        echo -e "${YELLOW}Attempting to stop bitwin24d${NC}"
        bitwin24-cli stop
        sleep 30
        if pgrep -x 'bitwin24d' > /dev/null; then
            echo -e "${RED}bitwin24d daemon is still running!${NC} \a"
            echo -e "${RED}Attempting to kill...${NC}"
            sudo pkill -9 bitwin24d
            sleep 30
            if pgrep -x 'bitwin24d' > /dev/null; then
                echo -e "${RED}Can't stop bitwin24d! Reboot and try again...${NC} \a"
                exit 2
            fi
        fi
    fi
}

killall bitwin24d 2>/dev/null  >/dev/null
killall bitwin24d 2>/dev/null  >/dev/null
killall bitwin24d 2>/dev/null  >/dev/null

#Process command line parameters
genkey=$1
clear

echo -e "${GREEN} 
  ---------- BitWin24 MASTERNODE UPDATER -----------
 |                                                  |
 |                                                  |
 |          The installation will update            |
 |            your BitWin24 Masternode!             |
 |                                                  |
 |            The privatekey and other data         |
 |               will not be touched!               |
 |                                                  |
 +--------------------------------------------------+
   ::::::::::::::::::::::::::::::::::::::::::::::::${NC}"
echo "Do you want to update your BitWin24 Masternode? [y/n]"
read DOSETUP

if [[ $DOSETUP =~ "n" ]] ; then
          exit 1
    fi
    
killall bitwin24d 2>/dev/null  >/dev/null
killall bitwin24d 2>/dev/null  >/dev/null
killall bitwin24d 2>/dev/null  >/dev/null

sleep .5
clear

#updating Daemon
cd ~
rm -rf /bitwin24-1.0.0
rm -rf /usr/local/bin/bitwin24*
wget ${COIN_ARH}
tar xvzf "${COIN_TGZ}"
cd /root/bitwin24-1.0.0/bin/  2>/dev/null  >/dev/null
sudo chmod -R 755 bitwin24-cli  2>/dev/null  >/dev/null
sudo chmod -R 755 bitwin24d  2>/dev/null  >/dev/null
cp -p -r bitwin24d /usr/local/bin  2>/dev/null  >/dev/null
cp -p -r bitwin24-cli /usr/local/bin  2>/dev/null  >/dev/null
bitwin24-cli stop  2>/dev/null  >/dev/null
rm ~/bitwin24-1.0.0-x86_64-linux-gnu.tar.gz*  2>/dev/null  >/dev/null

#Adding bootstrap files 

cd ~/.bitwin24/ && rm -rf backups blocks chainstate debug.log .lock mncache.dat peers.dat staking zerocoin banlist.dat budget.dat db.log fee_estimates.dat mnpayments.dat  sporks bootstrap*
cd ~/.bitwin24/ && wget ${BOOTSTRAP_LINK}
cd ~/.bitwin24/ && unzip bootstrap.zip

sleep 5 

cd ~/.bitwin24/ && rm -rf bootstrap.zip

bitwin24d -daemon 

echo -e "
${GREEN}...Masternode successfully updated!...${NC}

When the blockchain is fully synced start your masternode in the control wallet !

Here are some useful commands and tools for wallet troubleshooting:
========================================================================
To view wallet configuration produced by the first script in bitwin24.conf:
${GREEN}cat ~/.bitwin24/bitwin24.conf${NC}
Here is your bitwin24.conf generated by this script:
-------------------------------------------------${GREEN}"
echo -e ""
cat ~/.bitwin24/bitwin24.conf
echo -e "${NC}-------------------------------------------------
NOTE: To edit bitwin24.conf, first stop the bitwin24d daemon,
then edit the bitwin24.conf file and save it in nano: (Ctrl-X + Y + Enter),
then start the bitwin24d daemon back up:
to stop:              ${GREEN}bitwin24-cli stop${NC}
to start:             ${GREEN}bitwin24d${NC}
to edit:              ${GREEN}nano ~/.bitwin24/bitwin24.conf ${NC}
to check status:      ${GREEN}bitwin24-cli getinfo ${NC}
to check MN status:   ${GREEN}bitwin24-cli masternode status ${NC}
========================================================================
To monitor system resource utilization and running processes:
                   ${GREEN}htop${NC}
========================================================================
${GREEN}Have fun with your BitWin24 Masternode!${NC}

${RED}BitWin24 - the first real Blockchain Lottery${NC} 
"
rm ~/bwi_mnupdate.sh


