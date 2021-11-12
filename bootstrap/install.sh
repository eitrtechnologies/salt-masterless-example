#!/bin/bash

# Use the Salt Project bootstrap script to install Salt
curl -L https://bootstrap.saltproject.io | sudo sh -s -- -x python3 \
    -j '{"master_type": "disable", "file_roots": {"top": ["/srv/local/top"], "base": ["/srv/local/salt", "/srv/remote/salt"]}, "startup_states": "highstate", "pub_ret": False, "mine_enabled": False, "return": "rawfile_json", "top_file_merging_strategy": "merge_all"}' \
    stable 3004

# Make local directories
mkdir -p /srv/local/{salt,top}

# States for synchronized main state repo and highstate schedule
cat << EOF > /srv/local/salt/entrypoint.sls
sync_states:
  git.latest:
    - name: https://github.com/eitrtechnologies/salt-masterless-example.git
    - target: /srv/remote
    - force_checkout: True
    - force_clone: True
    - force_fetch: True
    - force_reset: True
    - submodules: True
    - order: 1

sync_all_modules:
  saltutil.sync_all:
    - refresh: True
    - order: 1
    - onchanges:
      - git: sync_states

highstate_schedule:
  schedule.present:
    - function: state.apply
    - cron: "*/30 * * * *"
EOF

# Top file in a fake environment to be merged with the remote top
cat << EOF > /srv/local/top/top.sls
base:
  "*":
    - entrypoint
EOF

# Run a highstate with the local files in place
salt-call state.apply
