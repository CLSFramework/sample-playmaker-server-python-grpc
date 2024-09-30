#!/bin/bash

# remove logs directory
rm -rf logs
# create logs directory
if [ ! -d "./logs" ]; then
  mkdir -p "./logs"
fi

# Ensure the script exits if any command fails
set -e
# check scripts/proxy directory does not exist, raise error
if [! -d scripts/proxy ]; then
    echo "scripts/proxy directory does not exist"
    exit 1
fi

team_name="CLS"
rpc_port=50051
debug=false

# help function
usage() {
    echo "Usage: $0 [options]"
    echo "Options:"
    echo "  -t team_name: specify team name"
    echo "  --rpc-port PORT - specifies rpc port (default: 50051)"
    exit 1
}

while [ $# -gt 0 ]
do
  case $1 in
    -t)
      team_name=$2
      shift
      ;;
    --rpc-port)
      rpc_port=$2
      shift
      ;;
    -d|--debug)
      debug=true
      ;;
    *)
      echo 1>&2
      echo "invalid option \"${1}\"." 1>&2
      echo 1>&2
      usage
      exit 1
      ;;
  esac

  shift 1
done

# Check Python requirements
echo "Checking Python requirements..."
python3 check_requirements.py

# Start server.py in the background
echo "Starting server.py..."
python3 server.py --rpc-port $rpc_port &
server_pid=$!

# Function to kill server and team processes on exit
cleanup() {
    echo "Cleaning up..."
    kill $server_pid
    kill $start_pid
}

# Trap the exit signal to cleanup processes
trap cleanup EXIT

# Wait a moment to ensure the server has started (optional)
sleep 2

# Start start.sh script in the correct directory with arguments
echo "Starting start.sh with team name: $team_name and ..."
log_dir="logs/proxy.log"
abspath=$(realpath $log_dir)
cd scripts/proxy
if [ "$debug" = true ]; then
  bash start-debug.sh -t "$team_name" --rpc-port $rpc_port --rpc-type grpc >> $abspath 2>&1 &
else
  bash start.sh -t "$team_name" --rpc-port $rpc_port --rpc-type grpc >> $abspath 2>&1 &
fi
start_pid=$!

# Wait for both background processes to finish
wait $server_pid
wait $start_pid
