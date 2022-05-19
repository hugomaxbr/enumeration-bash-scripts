#!/bin/sh

#Pra rodar isso aqui tu deve instalar o jq e o shodan, coisa simples.
#sudo apt install jq -y && sudo apt install python3-shodan
#Obviamente você vai precisar do python3 pro shodan
#Não esquece de dar chmod +x pro arquivo.
#Se não rodar mesmo assim aí tu dá teus pulo que eu não tenho bola de cristal também né.


blue=$(tput setaf 4)
normal=$(tput sgr0)

printf "${blue}subdomain look up from crt.sh \n${normal}"
printf "${blue}[!]Enter the domain to lookup: ${normal}"
read -r domain

printf "${blue}[...]Looking for $domain ${normal}"
allDomains=$(curl -s https://crt.sh/\?q\=$domain\&output\=json | jq . | grep name | cut -d":" -f2 | grep -v "CN=" | cut -d'"' -f2 | awk '{gsub(/\\n/,"\n");}1;' | sort -u)
printf "$allDomains\n" && echo "$allDomains" > "$domain"_subdomains.txt

printf "${blue}[*] Company Hosted Servers: \n${normal}"
for i in $(cat "$domain"_subdomains.txt);do host $i | grep "has address" | grep "$domain" | cut -d" " -f1,4 >> "$domain"_company_hosted.txt; done
cat ""$domain"_company_hosted.txt"

printf "${blue}[*] IPs from company hosted servers: \n${normal}"
for i in $(cat "$domain"_company_hosted.txt);do host $i | grep "has address" | grep "$domain" | cut -d" " -f4 >> "$domain"_ip_addresses.txt;done
cat ""$domain"_ip_addresses.txt"
for i in $(cat "$domain"_ip_addresses.txt);do sleep 2 && shodan host $i >> "$domain"_shodan.txt; done
cat ""$domain"_shodan.txt"