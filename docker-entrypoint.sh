#!/usr/bin/env sh
# Add local user
# Either use the LOCAL_USER_ID if passed in at runtime or
# fallback
USER_ID=${LOCAL_USER_ID:-0}
USER_NAME=${LOCAL_USER_NAME:-user}
GROUP_ID=${LOCAL_GROUP_ID:-0}
GROUP_NAME=${LOCAL_GROUP_NAME:-user}
DOCKER_GUID=${LOCAL_DOCKER_GUID:-0}

if [ $USER_ID -eq 0 ]
then
  USER_NAME=root
else
  groupadd -g $GROUP_ID -o $GROUP_NAME &>/dev/null
  # Start user configuration
  useradd --shell /bin/sh -u $USER_ID -g $GROUP_ID -o -c "" -m $USER_NAME &>/dev/null
  export HOME=/home/$USER_NAME
  mkdir -p /application
  mkdir -p /data
  chown -R $USER_NAME:$GROUP_NAME /home/$USER_NAME
  chown -R $USER_NAME:$GROUP_NAME /application
  chown -R $USER_NAME:$GROUP_NAME /data
fi

if [ $DOCKER_GUID -ne 0 ]
then
  groupmod -g $DOCKER_GUID docker &>/dev/null
  gpasswd -a $USER_NAME docker &>/dev/null
fi

exec gosu $USER_NAME "$@"