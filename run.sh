#!/bin/bash

set -Eeuo pipefail

# Prometheus settings
export SCALE="1" # 1 for seconds or 60 for minutes
export INTERVAL="$((SCALE * 5))s"
export OFFSET_STEP1="$((SCALE * 5))"
export OFFSET_STEP2="$((SCALE * 10))"

# Set the timings
export TS_NOW="$EPOCHSECONDS"
export TS_USERS_JOIN="$(( TS_NOW + SCALE * 10 ))"
export TS_DEVSPACES="$(( TS_NOW + SCALE * 20 ))"

# Superman is on time
export TS_USER_SUPERMAN_HERO="$(( TS_NOW + SCALE * 55 ))"
export TS_USER_SUPERMAN_VILLAIN="$(( TS_NOW + SCALE * 85 ))"
export TS_USER_SUPERMAN_FIGHT="$(( TS_NOW + SCALE * 130 ))"
export TS_USER_SUPERMAN_FIGHT_CALL="$(( TS_NOW + SCALE * 135 ))"

# Catwoman is early
export TS_USER_CATWOMAN_HERO="$(( TS_NOW + SCALE * 50 ))"
export TS_USER_CATWOMAN_VILLAIN="$(( TS_NOW + SCALE * 75 ))"
export TS_USER_CATWOMAN_FIGHT="$(( TS_NOW + SCALE * 115 ))"
export TS_USER_CATWOMAN_FIGHT_CALL="$(( TS_NOW + SCALE * 120 ))"

# Invisible Man is late
export TS_USER_INVISIBLEMAN_HERO="$(( TS_NOW + SCALE * 60 ))"
export TS_USER_INVISIBLEMAN_VILLAIN="$(( TS_NOW + SCALE * 95 ))"
export TS_USER_INVISIBLEMAN_FIGHT="$(( TS_NOW + SCALE * 145 ))"
export TS_USER_INVISIBLEMAN_FIGHT_CALL="$(( TS_NOW + SCALE * 150 ))"

# Batman is late but will catch up
export TS_USER_BATMAN_HERO="$(( TS_NOW + SCALE * 65 ))"
export TS_USER_BATMAN_VILLAIN="$(( TS_NOW + SCALE * 70 ))"
export TS_USER_BATMAN_FIGHT="$(( TS_NOW + SCALE * 100 ))"
export TS_USER_BATMAN_FIGHT_CALL="$(( TS_NOW + SCALE * 110 ))"

# Expected timings for the exercises
export TS_EXERCISE_HERO="$(( TS_NOW + SCALE * 55 ))"
export TS_EXERCISE_VILLAIN="$(( TS_NOW + SCALE * 85 ))"
export TS_EXERCISE_FIGHT="$(( TS_NOW + SCALE * 130 ))"
export TS_EXERCISE_FIGHT_CALL="$(( TS_NOW + SCALE * 135 ))"

# Process the template
envsubst < prometheus/prometheus.yaml.template > prometheus/prometheus.yaml
envsubst < prometheus/recording_rules.yaml.template > prometheus/recording_rules.yaml

# Reload recording rules and remove all data
podman stop prometheus || true
podman rm prometheus || true
podman volume rm opencodequest-leaderboard_prometheus_data || true
podman-compose up -d
podman logs -f prometheus
