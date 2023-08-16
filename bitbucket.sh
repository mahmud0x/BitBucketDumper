#!/bin/bash

read -p "Enter your Bitbucket username: " username
read -s -p "Enter your secret key or password: " secret_key
echo
read -p "Enter the workspace name: " workspace_name
read -p "Enter the total number of pages you want to check: " total_pages

output=""

for (( page = 1; page <= total_pages; page++ )); do
    page_output=$(curl -u "$username:$secret_key" -s "https://api.bitbucket.org/2.0/repositories/$workspace_name?sort=-updated_on&page=$page" | grep -o 'https://[^.]*@bitbucket.org/[^.]*\.git')
    output="$output$page_output"
done

output=${output//$username/$username:$secret_key}

echo "$output"

read -p "Do you want to download the repositories? (y/n): " choice

if [[ $choice == "y" || $choice == "Y" ]]; then
    # Clone repositories
    IFS=$'\n'
    for repo_url in $output; do
        git clone "$repo_url"
    done
    echo "Repositories downloaded successfully."
else
    echo "Repositories not downloaded."
fi
