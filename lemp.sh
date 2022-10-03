Off='\033[0m' # Text Reset

# Regular Colors
Black='\033[0;30m'  # Black
Red='\033[0;31m'    # Red
Green='\033[0;32m'  # Green
Yellow='\033[0;33m' # Yellow
Blue='\033[0;34m'   # Blue
Purple='\033[0;35m' # Purple
Cyan='\033[0;36m'   # Cyan
White='\033[0;37m'  # White

# Bold
BBlack='\033[1;30m'  # Black
BRed='\033[1;31m'    # Red
BGreen='\033[1;32m'  # Green
BYellow='\033[1;33m' # Yellow
BBlue='\033[1;34m'   # Blue
BPurple='\033[1;35m' # Purple
BCyan='\033[1;36m'   # Cyan
BWhite='\033[1;37m'  # White

# Underline
UBlack='\033[4;30m'  # Black
URed='\033[4;31m'    # Red
UGreen='\033[4;32m'  # Green
UYellow='\033[4;33m' # Yellow
UBlue='\033[4;34m'   # Blue
UPurple='\033[4;35m' # Purple
UCyan='\033[4;36m'   # Cyan
UWhite='\033[4;37m'  # White

# Background
On_Black='\033[40m'  # Black
On_Red='\033[41m'    # Red
On_Green='\033[42m'  # Green
On_Yellow='\033[43m' # Yellow
On_Blue='\033[44m'   # Blue
On_Purple='\033[45m' # Purple
On_Cyan='\033[46m'   # Cyan
On_White='\033[47m'  # White

# High Intensity
IBlack='\033[0;90m'  # Black
IRed='\033[0;91m'    # Red
IGreen='\033[0;92m'  # Green
IYellow='\033[0;93m' # Yellow
IBlue='\033[0;94m'   # Blue
IPurple='\033[0;95m' # Purple
ICyan='\033[0;96m'   # Cyan
IWhite='\033[0;97m'  # White

# Bold High Intensity
BIBlack='\033[1;90m'  # Black
BIRed='\033[1;91m'    # Red
BIGreen='\033[1;92m'  # Green
BIYellow='\033[1;93m' # Yellow
BIBlue='\033[1;94m'   # Blue
BIPurple='\033[1;95m' # Purple
BICyan='\033[1;96m'   # Cyan
BIWhite='\033[1;97m'  # White

# High Intensity backgrounds
On_IBlack='\033[0;100m'  # Black
On_IRed='\033[0;101m'    # Red
On_IGreen='\033[0;102m'  # Green
On_IYellow='\033[0;103m' # Yellow
On_IBlue='\033[0;104m'   # Blue
On_IPurple='\033[0;105m' # Purple
On_ICyan='\033[0;106m'   # Cyan
On_IWhite='\033[0;107m'  # White

welcome() {
    echo -e "${Green}Welcome to the One-script LEMP installer${Off}"
    echo "This script will install and configure Linux, Nginx, MySQL, PHP"
    echo -e "On your ${On_Yellow}$(command lsb_release -d -s)${Off} server."
    echo " "
    echo "This script is provided as-is, without warranty of any kind."
    echo "Use at your own risk."
    echo " "
    tput sc
    echo -e "${Red}Press any key to continue or CTRL+C to cancel.${Off}"
    read -n 1 -s
    tput rc
    tput el
    echo "Nice choice!"
    echo ""
    sleep 1
}

core() {
    tput sc
    echo -e "> ${Yellow}Update and upgrade the system...${Off}"
    sudo apt-get -qq update && apt-get -qq upgrade -y
    tput rc
    tput el
    echo -e "- ${Green}Core Linux updated and upgraded.${Off} ✅"
    apt list --upgradable
    echo ""
}

install_nginx() {
    if [ -x "$(command -v nginx)" ]; then
        echo -e "- ${Green}Nginx already installed.${Off} ✅"
        nginx -v
        echo ""
    else
        tput sc
        echo -e "> ${Yellow}Installing Nginx...${Off}"
        sudo apt-get -qq install nginx -y > /dev/null
        sleep 1
        if [ -x "$(command -v nginx)" ]; then
            tput rc
            tput el
            echo -e "- ${Green}Nginx installed.${Off} ✅"
            nginx -v
            echo ""
        fi
    fi
}
install_mysql() {
    if [ -x "$(command -v mysql)" ]; then
        echo -e "- ${Green}MySQL already installed.${Off} ✅"
        mysql --version
        echo ""
    else
        tput sc
        echo -e "> ${Yellow}Installing MySQL${Off}"
        sudo apt-get -qq install mysql-server -y > /dev/null
        echo ""
        sleep 1
        if [ -x "$(command -v mysql)" ]; then
            tput rc
            tput el
            echo -e "- ${Green}MySQL installed.${Off} ✅"
            mysql --version
            echo ""
        fi
    fi
}
install_php() {
    if [ -x "$(command -v php)" ]; then
        echo -e "- ${Green}PHP already installed.${Off} ✅"
        php -v
        echo ""
    else
        tput sc
        echo -e "> ${Yellow}Installing PHP${Off}"
        sudo apt-get -qq install php-fpm php-mysql -y > /dev/null
        echo ""
        sleep 1
        if [ -x "$(command -v php)" ]; then
            tput rc
            tput el
            echo -e "- ${Green}PHP installed.${Off} ✅"
            php -v
            echo ""
        fi
    fi
}

php_info(){
    sysctl -w net.ipv6.conf.all.disable_ipv6=1
    sysctl -w net.ipv6.conf.default.disable_ipv6=1
    ip=$(curl -s http://ifconfig.io) > /dev/null
    echo "<?php infophp();" > /var/www/html/info.php
    echo "Home: http://${ip}"
    echo "PHP info: http://${ip}/info.php"
    echo ""
}

firewall(){
    tput sc
    echo -e "> ${Yellow}Configuring firewall...${Off}"
    echo "Allow OpenSSH"
    sudo ufw allow OpenSSH
    echo "Allow Nginx Full"
    sudo ufw allow 'Nginx Full'
    echo "Allow ssh"
    sudo ufw allow ssh
    echo "Enable firewall"
    sudo ufw enable
    sudo ufw status
    echo ""
    sleep 1
    tput rc
    tput el
    echo -e "- ${Green}Firewall configured.${Off} ✅"
    echo ""
}

welcome
core
install_nginx
install_mysql
install_php
php_info