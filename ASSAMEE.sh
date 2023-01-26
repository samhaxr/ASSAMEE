#!/bin/bash
#!Coded by Suleman Malik
#!www.sulemanmalik.com
#!Twitter: @sulemanmalik_3
#!Linkedin: http://linkedin.com/in/sulemanmalik03/
#
# Copyright (c) 2022 Suleman Malik
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
# TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS
# BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

Anon_key="" # Anon API KEY HERE
# Get Your API_KEY from https://anonfiles.com/register

EncLoad(){
        read -r -p "${cr}Folder: " __DIR__; [ -z "${__DIR__}" ]&& main; absolute=$(realpath ${__DIR__} ) > /dev/null 2>&1
        if [ -d "${absolute}" ];then connectivity; echo "\033[01;33m[-]\033[0m Creating Archive";
                zip -r -X ${logdir}/${__DIR__}.zip ${__DIR__} > /dev/null 2>&1;echo "\033[01;33m[-]\033[0m Encrypting Archive";
                openssl aes-256-cbc -a -salt -in ${logdir}/${__DIR__}.zip -out ${logdir}/${__DIR__}.enc -md sha256
                cat ${logdir}/${__DIR__}.enc | base64 > ${logdir}/${__DIR__}.samhax;echo "\033[01;33m[-]\033[0m Uploading please wait...";
                req=$(curl -F "file=@${logdir}/${__DIR__}.samhax" https://api.anonfiles.com/upload${param} > ${logdir}/anonxe;)
                full_id=$(jq .data.file.metadata.id ${logdir}/anonxe | sed 's/"//g');
                err=$(jq .error.message ${logdir}/anonxe | sed 's/"//g'); status=$(jq .status ${logdir}/anonxe | sed 's/"//g');
                [ "${status}" = "false" ]&& echo "\033[01;31m[!]\033[0m ${err}"  \
                || bod;echo "\033[01;32m[+]\033[0m Download ID: \033[01;32m ${full_id}\033[0m";
        else
                echo "\033[01;31m[!]\033[0m No such file or directory";
        fi;sleep 3;
}

DecLoad(){
        read -r -p "${cr}Download ID: " id;[ -z ${id} ]&& main;connectivity;
        info=$(curl -s https://api.anonfiles.com/v2/file/${id}/info > ${logdir}/anonx);
        [ "${#id}" -le 5 ]&& echo "\033[01;31m[!]\033[0m Invalid Download ID..." && main;
        [ "${#id}" -ge 11 ]&& echo "\033[01;31m[!]\033[0m Invalid Download ID..." && main;
        err_str=$(jq .error.message ${logdir}/anonx | sed 's/"//g')
        name=$(jq .data.file.metadata.name ${logdir}/anonx | sed 's/"//g' | sed 's/_/./')
        size=$(jq .data.file.metadata.size.readable ${logdir}/anonx | sed 's/"//g')
        status=$(jq .status ${logdir}/anonx | sed 's/"//g'); err=$(jq .error.message ${logdir}/anonx \
        | sed 's/"//g');[ "${status}" = "false" ]&& echo "\033[01;31m[!]\033[0m $err_str" && main;
        link=$(curl -s https://anonfiles.com/${id}/ | grep -o 'href="[^"]*\.samhax"' | sed 's/href=//g' | sed 's/"//g'); 
	echo "\033[01;32m[+]\033[0m Status: Found";
        echo "\033[01;33m[-]\033[0m Name: ${name}"; echo "\033[01;33m[-]\033[0m Size: ${size}\n";
        read -r -p "Download file? [y/N] " response;
        [ "$response" = "N" ] || [ "$response" = "n" ]&& main;[ -z "${response}" ]&& main;
        curl ${link} --output ${logdir}/${name};bod; __DIR__=$(echo ${name} | sed 's/.samhax//g');
        cat ${logdir}/${__DIR__}.samhax | base64 -d > ${logdir}/${__DIR__}.enc
        openssl aes-256-cbc -d -a -in "${logdir}/${__DIR__}.enc" -out "${PWD}/${__DIR__}.zip" -md sha256
        echo "\033[01;33m[-]\033[0m Extracting Archive ${__DIR__}"
        [ -d "$PWD/${__DIR__}" ]&& rm -rf $PWD/${__DIR__} > /dev/null 2>&1;
        unzip ${__DIR__}.zip > /dev/null 2>&1; echo "\033[01;32m[+]\033[0m Done\033[0m"
}

libs(){
        checkOS;if [ "$machine" = "Linux" ]
        then
                echo "\033[01;33m[!]\033[0m  Installing required packages...\n"; \
                sudo apt install zip -y && \
                sudo apt install curl -y && sudo apt install openssl -y && sudo apt \
                install jq -y;
        elif [ "$machine" = "Mac" ]
        then
                echo "\033[01;33m[!]\033[0m  Installing required packages...\n";
                brew install jq
                brew install coreutil
        else
                echo "\n${RED}[!] The current Operating System does not support this program. Exiting...${RESTORE}\n"; sleep 3;exit 1;
        fi
}

checkOS(){
        oscheck="$(uname -s)"
        case "${oscheck}" in
            Linux*)     machine=Linux;;
            Darwin*)    machine=Mac;;
            CYGWIN*)    machine=Cygwin;;
            MINGW*)     machine=MinGw;;
            *)          machine="UNKNOWN:${oscheck}"
        esac
}

bod(){
        echo '==============================================' 
}

banner(){
        echo "
╔═╦╦╦╗╔╦═╦═╦═╦═╦╦╦╦╦╦╦═╦╦╦╦╗ 
║║║║║╠╝║║╚╣║║║║║║║║║║║║║║║║║
║║║║║╚╦╦═╦╦╦╦╣║║║║║║║║║║║║║║
║║║║╠═╣╠╝╔══╝║║║║║╟╢║║║║║╟╢║
╚╩══╩══╩═╩═══╩╩══╩╩═╩╩╩═╩╩═╝
\033[0;32mby @sulemanmalik_3\tV1.0\033[0m";
echo "============================"
}

connectivity(){
        if nc -zw1 google.com 443 >/dev/null 2&>1; then
                echo "\033[01;32m[+]\033[0m Connection : OK"
        else
                echo "\033[01;31m[!]\033[0mcheck your internet connection and then try again...";exit 1
        fi
}

main(){
        rm -rf ${logdir} > /dev/null 2>&1;rm 1 ${__DIR__}.zip > /dev/null 2>&1;
        banner; logdir="/tmp/anonx"; mkdir ${logdir} > /dev/null 2>&1;
        x_char=$(echo ${Anon_key} | awk '{print substr($0,13,16)}');
        param="?token=${Anon_key}"; [ -z ${Anon_key} ]&& echo \
        "\033[01;31m[!]\033[0m API Key [\033[01;31mNot Found\033[0m]" \
        || echo "\033[01;32m[+]\033[0m API Key [\033[01;32mX-${x_char}\033[0m]"
        echo "\n[1] Upload \n[2] Download\n[3] PKG Installer\n[0] Exit\n"
        read -r -p "=> " choice;choice=$(echo ${choice} | grep -x -E \
        '[[:digit:]]+');[ -z ${choice} ]&& main;
        if [ "${choice}" -eq 1 ]
        then
                EncLoad
        elif [ "${choice}" -eq 2 ]
        then
                DecLoad
        elif [ "${choice}" -eq 3 ]
        then
                libs
        elif [ "${choice}" -eq 0 ]
        then
                exit 1;
        else
                echo "\nWrong choice. Try again..."
        fi
}

while true;do main;done
