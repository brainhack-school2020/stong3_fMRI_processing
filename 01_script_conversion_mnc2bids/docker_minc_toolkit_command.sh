docker run -it --rm \
    -w="/script_conversion" \
    -v /Users/stong3/Desktop/bhs_project/sourcedata:/files_to_convert:ro \
    -v /Users/stong3/Desktop/bhs_project/rawdata:/converted_files \
    -v /Users/stong3/Desktop/BHS2020_Project/01_script_conversion_mnc2bids:/script_conversion \
    nistmni/minc-toolkit