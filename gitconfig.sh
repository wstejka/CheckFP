#!/bin/sh

httpProxyIPAndPort=""
actionType=""

function usage
{
    echo "usage: $0 [option] ... [[-u] | [[-s] & [-p "ip:port"]]"
}

while getopts "usp:" opt; do
    case "$opt" in
    u)  actionType="unset"
        ;;
    s)  actionType="set"
        ;;
    p)  httpProxyIPAndPort=$OPTARG
        ;;
    *)
	usage
    esac
done

if [[ "$actionType" == "set" ]]
then
	if [[ $httpProxyIPAndPort == "" ]]
	then
		usage
		exit 1
	fi
	# TODO: validate httpProxyIPAndPort 
	
	echo "setting proxy: $httpProxyIPAndPort"
	#git config --global http.proxy http_proxy=http://$httpProxyIPAndPort
	git config http.proxy http_proxy=http://$httpProxyIPAndPort
	git config https.proxy https_proxy=https://$httpProxyIPAndPort
else
	echo "unsetting proxy"
	git config --unset http.proxy
	git config --unset https.proxy
fi

#git config --global http.proxy http_proxy=http://135.245.192.7:8000

