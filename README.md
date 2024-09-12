# Nautilus Script: Generate a PDF file from multiple images

This script allows you to select multiple image files in Nautilus, right-click, and resize, compress and generate a single PDF file from them.

## Installation

To use this script with Nautilus, follow these steps:

1. Make sure `imagemagick` and `zenity` are installed. If they're not, you can install them using:
   ```
   sudo apt install imagemagick zenity
   ```

2. Copy the script to the Nautilus scripts directory:
   ```
   mkdir -p ~/.local/share/nautilus/scripts
   wget https://raw.githubusercontent.com/marc-farre/nautlius-script-resize-images/main/Resize_Images.sh -O ~/.local/share/nautilus/scripts/Resize_Images.sh
   ```

3. Make the script executable:
   ```
   chmod +x ~/.local/share/nautilus/scripts/Generate_PDF.sh
   ```

4. Restart Nautilus for the changes to take effect:
   ```
   nautilus -q
   ```
   
## Usage

To use this script:

1. Select the image files you want to process in Nautilus.
2. Right-click and go to "Scripts" > "Resize_Images".
3. Enter the name of the PDF file to generate
4. The script will process each image and save the result in the same directory as the original files, in a single PDF file
