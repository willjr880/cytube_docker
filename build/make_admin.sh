#!/bin/sh
if [ -z "$1" ]; then
  echo "Please provide a username."
else
mariadb -u cytube3 -p$CYTUBE_MARIADB_PASSWORD <<EOF
USE cytube3;
UPDATE users SET global_rank=255 WHERE name='$1';
EOF
ret=$?
  if [ "$ret" = "0" ]; then
    echo "User $1 is now an admin (provided they exist in the database)."
  else
    echo "An error occurred."
  fi
fi
