#!/bin/sh

user="ug3qNLiRgCLDPSzk6EBjttZ3xBwfEp"
token="abKyv41GvmrmRU7n5xW9EVZZCy38BE"

curl -s --form-string "token=$token"\
        --form-string "user=$user"\
        --form-string "message=$1"\
        https://api.pushover.net/1/messages.json
