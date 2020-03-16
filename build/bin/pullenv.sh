#!/bin/bash
# Important for passing the Docker environment through to SSH.
# /etc/gearbox/bin/JsonToConfig -json-string '{}' -template /etc/gearbox/etc/pullenv.tmpl > /etc/environment
/etc/gearbox/bin/JsonToConfig -template-string '{{ PrintEnv }}' -out /etc/environment
cp /etc/environment /etc/profile.d/00-gearbox.sh
