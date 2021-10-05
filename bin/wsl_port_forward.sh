#!/bin/bash

IP=`hostname -I`

netsh.exe interface portproxy delete v4tov4 listenport=2222
netsh.exe interface portproxy add v4tov4 listenport=2222 connectport=2222 connectaddr=${IP}

exit 0