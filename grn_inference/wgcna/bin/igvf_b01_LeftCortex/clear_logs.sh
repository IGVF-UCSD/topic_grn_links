# Remove log files from ./logs/ directory, prompt user first
# Usage: bash clear_logs.sh

# Get absolute path to logs/ directory
curr_dir=$(pwd)
logs_dir=$curr_dir/logs

# Prompt user
echo "Are you sure you want to delete all files in $logs_dir? (y/n)"
read response

# If user responds with y, delete all files in logs/ directory
if [ "$response" == "y" ]; then
    rm -f $logs_dir/*.log
    echo "Deleted all files in $logs_dir"
else
    echo "Did not delete any files"
fi