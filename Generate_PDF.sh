#!/bin/bash

# Nautilus script to convert selected images (JPG or PNG) to a PDF file
# Save this script in ~/.local/share/nautilus/scripts/
# Make it executable with: chmod +x ~/.local/share/nautilus/scripts/Images_to_PDF.sh

# Function to log messages
log_message() {
    # Uncomment to log
    # echo "$1" >> /tmp/nautilus_pdf_debug.log
}

log_message "----------------------------------------"
log_message "Script started at $(date)"

# Check if ImageMagick is installed
if ! command -v convert &> /dev/null; then
    zenity --error --text="ImageMagick is not installed. Please install it using:\nsudo apt-get install imagemagick"
    log_message "ImageMagick not installed"
    exit 1
fi

# Get the current directory
current_dir=$(pwd)
log_message "Current directory: $current_dir"

# Log the raw NAUTILUS_SCRIPT_SELECTED_FILE_PATHS
log_message "Raw NAUTILUS_SCRIPT_SELECTED_FILE_PATHS:"
log_message "$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"

# Create an array to store valid image files
mapfile -d $'\0' -t all_files <<< "$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"
declare -a valid_files

log_message "All files after mapfile:"
for file in "${all_files[@]}"; do
    log_message "  $file"
done

# Process each selected file
for file in "${all_files[@]}"; do
    if [[ $file =~ \.(jpe?g|png)$ ]]; then
        valid_files+=("$file")
        log_message "Added valid file: $file"
    else
        log_message "Skipped invalid file: $file"
    fi
done

# Log the number of valid files
log_message "Number of valid files: ${#valid_files[@]}"

# Check if any valid image files were selected
if [ ${#valid_files[@]} -eq 0 ]; then
    zenity --error --text="No JPG or PNG files were selected."
    log_message "No valid files selected"
    exit 1
fi

# Prompt user for output PDF filename
output_pdf=$(zenity --file-selection --save --filename="$current_dir/output.pdf" --file-filter="PDF files (pdf) | *.pdf" --title="Save PDF as...")

# Check if user cancelled the file selection
if [ -z "$output_pdf" ]; then
    log_message "User cancelled file selection"
    exit 0
fi

log_message "Output PDF: $output_pdf"

# Prepare the convert command
convert_command="convert"
for file in "${valid_files[@]}"; do
    convert_command+=" \"$file\""
done
convert_command+=" -quality 100 \"$output_pdf\""

log_message "Convert command: $convert_command"

# Execute the convert command
log_message "Executing convert command..."
eval $convert_command 2>> /tmp/nautilus_pdf_debug.log
convert_exit_code=$?
log_message "Convert command exit code: $convert_exit_code"

# Check if the conversion was successful
if [ $convert_exit_code -eq 0 ]; then
    zenity --info --text="PDF created successfully:\n$output_pdf"
    log_message "PDF created successfully"
else
    error_message=$(tail -n 5 /tmp/nautilus_pdf_debug.log)
    zenity --error --text="Error creating PDF. Please check the log file at /tmp/nautilus_pdf_debug.log\n\nLast few lines of error:\n$error_message"
    log_message "Error creating PDF"
fi

log_message "Script ended at $(date)"
log_message "----------------------------------------"