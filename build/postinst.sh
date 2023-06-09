#!/bin/sh
mariadb -u root -p$MARIADB_ROOT_PASSWORD <<EOF
GRANT USAGE ON *.* TO cytube3 IDENTIFIED BY '$CYTUBE_MARIADB_PASSWORD';
GRANT ALL PRIVILEGES ON cytube3.* TO cytube3;
CREATE DATABASE cytube3;
EOF
