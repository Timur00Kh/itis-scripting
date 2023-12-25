#!/bin/bash

usage="Usage: $(basename $0) [--path dirpath] [--mask mask of file] [--number number of cores] command"
if [ -z "$1" ]; then
   echo "$usage"
   exit 1
fi
dir_path=$(pwd)
mask="*"
#number_of_cores=$(grep processor /proc/cpuinfo | wc -l)    # For Linux
number_of_cores=$(sysctl -n hw.ncpu)                        # For MacOS
command=""
command_parsed=false
while (( "$#" )); do
  case "$1" in
    --path)
      if [ $command_parsed != "true" ]; then
        if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
          dir_path=$2
          shift 2
        else
          echo -e "Error: Argument for $1 is missing\n$usage" >&2
          exit 1
        fi
      else
        command="$command $1"
        shift
      fi
      ;;
    --mask)
      if [ $command_parsed != "true" ]; then
        if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
          mask=$2
          shift 2
        else
          echo -e "Error: Argument for $1 is missing\n$usage" >&2
          exit 1
        fi
      else
        command="$command $1"
        shift
      fi
      ;;
    --number)
      if [ $command_parsed != "true" ]; then
        if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
          number_of_cores=$2
          shift 2
        else
          echo -e "Error: Argument for $1 is missing\n$usage" >&2
          exit 1
        fi
      else
        command="$command $1"
        shift
      fi
      ;;
    -*|--*=) # unsupported flags
      if [ $command_parsed != "true" ]; then
        echo -e"Error: Unsupported flag $1\n$usage" >&2
        exit 1
      else
        command="$command $1"
        shift
      fi
      ;;
    *) # preserve positional arguments
      if [ ! -z "$1" ]; then
        command="$command $1"
        command_parsed=true
        shift
      else
        if [ -z "$command" ]; then
          echo -e "Command is missing\n$usage" >&2
          exit 1
        fi
      fi
      ;;
  esac
done
echo "$command"
files=($(find "$dir_path" -maxdepth 1 -mindepth 1 -type f -name "$mask"))
files_size="${#files[@]}"
if [ "$files_size" -lt "$number_of_cores" ]; then
  for (( i = 0; i < files_size; i++ )); do
    echo "$command ${files[i]} &" | bash >> /dev/null
  done
else
  command_array=()
  command_iterator=0
  for (( i = 0; i < "$files_size"; i++ )); do
    if [ -z "${command_array[$command_iterator]}" ]; then
      command_array[$command_iterator]="$command ${files[i]} "
    else
      command_array[$command_iterator]="${command_array[$command_iterator]} && $command ${files[i]} "
    fi
    if [ $command_iterator -eq $((number_of_cores - 1)) ]; then
      command_iterator=0
    else
      command_iterator=$((command_iterator+=1))
    fi
  done
  for (( i = 0; i < "${#command_array[@]}"; i++ )); do
    echo "${command_array[$i]} &" | bash >> /dev/null
  done
fi


