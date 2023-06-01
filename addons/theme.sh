#!/bin/bash

# THEMES

mkdir -p /etc/Lawnetwork/theme

#Red
cat <<EOF>> /etc/Lawnetwork/theme/red
BG : \E[40;1;41m
TEXT : \033[0;31m
EOF

#Blue
cat <<EOF>> /etc/Lawnetwork/theme/blue
BG : \E[40;1;44m
TEXT : \033[0;34m
EOF

#Green
cat <<EOF>> /etc/Lawnetwork/theme/green
BG : \E[40;1;42m
TEXT : \033[0;32m
EOF

#Yellow
cat <<EOF>> /etc/Lawnetwork/theme/yellow
BG : \E[40;1;43m
TEXT : \033[0;33m
EOF

#Magenta
cat <<EOF>> /etc/Lawnetwork/theme/magenta
BG : \E[40;1;43
TEXT : \033[0;35m
EOF

#Cyan
cat <<EOF>> /etc/Lawnetwork/theme/cyan
BG : \E[40;1;46m
TEXT : \033[0;36m
EOF

#Theme configuration
cat <<EOF>> /etc/Lawnetwork/theme/color.conf
cyan
EOF
