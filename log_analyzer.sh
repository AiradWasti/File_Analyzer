#!/bin/bash

# Log File Analyzer Script

# Function to count occurrences of a specific log level
count_log_level() {
    local log_file=$1
    local log_level=$2
    echo "Counting occurrences of $log_level in $log_file"
    grep -i "$log_level" "$log_file" | wc -l
}

# Function to extract log entries matching a specific pattern
extract_pattern() {
    local log_file=$1
    local pattern=$2
    echo "Extracting entries matching pattern '$pattern' in $log_file"
    grep -i "$pattern" "$log_file"
}

# Function to summarize log file information
summarize_log() {
    local log_file=$1
    echo "Summary of $log_file"
    echo "Total lines: $(wc -l < "$log_file")"
    echo "Error entries: $(count_log_level "$log_file" "ERROR")"
    echo "Warning entries: $(count_log_level "$log_file" "WARNING")"
}

# Check if log file is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <log_file> [options]"
    echo "Options:"
    echo "  -c <level>   Count occurrences of log level (e.g., ERROR, WARNING)"
    echo "  -e <pattern> Extract entries matching pattern"
    echo "  -s           Summarize log file"
    exit 1
fi

log_file=$1
shift

# Process options
while getopts ":c:e:s" opt; do
    case $opt in
        c)
            log_level=$OPTARG
            count_log_level "$log_file" "$log_level"
            ;;
        e)
            pattern=$OPTARG
            extract_pattern "$log_file" "$pattern"
            ;;
        s)
            summarize_log "$log_file"
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            ;;
        :)
            echo "Option -$OPTARG requires an argument." >&2
            ;;
    esac
done
