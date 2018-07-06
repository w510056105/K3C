#!/bin/sh /etc/rc.common

# Copyright (c) 2018 paldier <paldier@hotmail.com>

START=99

start()
{
local start start2
start=$(uci get wireless.wlan0.disabled)
start2=$(uci get wireless.wlan2.disabled)


#--------- fapi_wlan_cli init . -----------
if [ ! -n "`lsmod | grep directconnect_datapath`" ]
then
insmod /lib/modules/3.10.104/directconnect_datapath.ko
insmod /lib/modules/3.10.104/dc_mode0-xrx500.ko
fi
if [ ! -e /opt/lantiq/wave/db/default ]; then
fapi_wlan_cli createConfig
fi
fapi_wlan_cli init
[ "$start" = "1" ] && fapi_wlan_cli setRadioEnabled -i 0 -e false
[ "$start2" = "1" ] && fapi_wlan_cli setRadioEnabled -i 2 -e false
#--------- fapi_wlan_cli init End. -----------
}

restart()
{
fapi_wlan_cli unInit
kill -9 $(ps |grep hostapd |cut -c1-5)
    local ssid2 ssid5 sec2 sec5 pwd2 pwd5 ch2 ch5 reg2 reg5 ssid2t ssid5t sec2t sec5t pwd2t pwd5t reg2t reg5t icount
    ssid2=$(uci get wireless.def_wlan0.ssid)
    sec2=$(uci get wireless.def_wlan0.encryption)
    pwd2=$(uci get wireless.def_wlan0.key)
    ch2="0"
    reg2=$(uci get wireless.wlan0.country)
    ssid5=$(uci get wireless.def_wlan2.ssid)
    sec5=$(uci get wireless.def_wlan2.encryption)
    pwd5=$(uci get wireless.def_wlan2.key)
    ch5="0"
    reg5=$(uci get wireless.wlan2.country)
    ssid2t=$(fapi_wlan_cli getSsid -i 0 |grep cli_return |cut -c12-64)
    ssid5t=$(fapi_wlan_cli getSsid -i 2 |grep cli_return |cut -c12-64)
    sec2t=$(fapi_wlan_cli getAuthMode -i 0 |grep cli_return |cut -c12-64)
    sec5t=$(fapi_wlan_cli getAuthMode -i 2 |grep cli_return |cut -c12-64)
    pwd2t=$(fapi_wlan_cli getKeyPassphrase -i 0 |grep cli_return |cut -c12-64)
    pwd5t=$(fapi_wlan_cli getKeyPassphrase -i 2 |grep cli_return |cut -c12-64)
    reg2t=$(fapi_wlan_cli getCountryCode -i 0 |grep cli_return |cut -c12-64)
    reg5t=$(fapi_wlan_cli getCountryCode -i 2 |grep cli_return |cut -c12-64)

	case "$sec2" in 
	wpa*|psk*|WPA*|Mixed|mixed)
        local sectt
		case "$sec2" in
			Mixed|mixed|psk+psk2|psk-mixed*)
				sectt="WPA-WPA2-Personal"
			;;
			WPA2*|wpa2*|psk2*)
				sectt="WPA2-Personal"
			;;
			WPA*|WPA1*|wpa*|wpa1*|psk*)
				sectt="WPA-Personal"
			;;
			esac
		case "$sec2" in
			*tkip+aes*|*tkip+ccmp*|*aes+tkip*|*ccmp+tkip*)
				sectt="WPA-WPA2-Enterprise"
			;;
			*aes*|*ccmp*)
				sectt="WPA2-Enterprise"
			;;
			*tkip*) 
				sectt="WPA-Enterprise"
			;;
			esac
        sec2=sectt
	;;
	WEP|wep|wep-open|wep-shared)
        sec2="WEP-128"
		;;
	none|open)
		sec2="None"
		;;
	esac

	case "$sec5" in 
	wpa*|psk*|WPA*|Mixed|mixed)
        local sect
		case "$sec5" in
			Mixed|mixed|psk+psk2|psk-mixed*)
				sect="WPA-WPA2-Personal"
			;;
			WPA2*|wpa2*|psk2*)
				sect="WPA2-Personal"
			;;
			WPA*|WPA1*|wpa*|wpa1*|psk*)
				sect="WPA-Personal"
			;;
			esac
		case "$sec5" in
			*tkip+aes*|*tkip+ccmp*|*aes+tkip*|*ccmp+tkip*)
				sect="WPA-WPA2-Enterprise"
			;;
			*aes*|*ccmp*)
				sect="WPA2-Enterprise"
			;;
			*tkip*) 
				sect="WPA-Enterprise"
			;;
			esac
        sec5=sect
	;;
	WEP|wep|wep-open|wep-shared)
        sec5="WEP-128"
		;;
	none|open)
		sec5="None"
		;;
	esac
    if [ "ssid2" != "ssid2t" ] || [ "sec2" != "sec2t" ] || [ "pwd2" != "pwd2t" ] || [ "reg2" != "reg2t" ] || [ "ssid5" != "ssid5t" ] || [ "sec5" != "sec5t" ] || [ "pwd5" != "pwd5t" ] || [ "reg5" != "reg5t" ]; then
        fapi_wlan_cli setSsid $ssid2 -i 0
        fapi_wlan_cli setSsid $ssid5 -i 2 
        fapi_wlan_cli setAuthMode $sec2 -i 0
        fapi_wlan_cli setAuthMode $sec5 -i 2
        fapi_wlan_cli setKeyPassphrase $pwd2 -i 0
        fapi_wlan_cli setKeyPassphrase $pwd5 -i 2
        #fapi_wlan_cli setKeyPassphrase $ch2 $ch5 $reg2 $reg5
        fapi_wlan_cli setCountryCode $reg2 -i 0
        fapi_wlan_cli setCountryCode $reg5 -i 2
    fi
#--------- fapi_wlan_cli init . -----------
if [ ! -n "`lsmod | grep directconnect_datapath`" ]
then
insmod /lib/modules/3.10.104/directconnect_datapath.ko
insmod /lib/modules/3.10.104/dc_mode0-xrx500.ko
fi
fapi_wlan_cli init
#--------- fapi_wlan_cli init End. -----------
}

