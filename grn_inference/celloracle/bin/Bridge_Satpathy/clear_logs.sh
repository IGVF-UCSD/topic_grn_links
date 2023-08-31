# Remove err and out files from err/ and out/ directories, prompt user first
# Usage: bash clear_logs.sh

# Prompt user
echo "Are you sure you want to delete all files in err/ and out/ directories? (y/n)"
read response

# If user responds with y, delete all files in err/ and out/ directories
if [ "$response" == "y" ]; then
    rm -f err/*.err
    rm -f out/*.out
    echo "Deleted all files in err/ and out/ directories"
else
    echo "Did not delete any files"
fi