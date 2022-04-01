#!/bin/bash

#Create CSV file
readonly CSV_FILE_NAME=wikipedia_dataset.csv

if [[ ! -f $CSV_FILE_NAME ]]
then
    echo "categories,content" > $CSV_FILE_NAME
fi

addNewArticleToCsv() {
    #Get the title
    random_url=$(curl -s "https://en.wikipedia.org/wiki/Special:Random" -i | grep location)
    random_url=${random_url::-1}
    [[ "$1" == "verbose" ]] && echo "url: $random_url"

    random_title=$(echo "$random_url" | awk -F/ '{print $NF}')
    [[ "$1" == "verbose" ]] && echo "random_title: $random_title"

    #Get the categories
    categories=$(curl -s "https://en.wikipedia.org/wiki/$random_title" | grep -oP "<div id=\"mw-normal-catlinks\"(.*?)<\/div>" | grep -oP "title=([\"\'])Category:(.*?)\"" | awk -F: '{print $NF}' | tr '\n' ' ' | tr '"' '|')
    categories="$random_title| $categories" 
    [[ "$1" == "verbose" ]] && echo "categories: $categories"


    #Get the json with the content
    json=$(curl -s "https://en.wikipedia.org/w/api.php?format=json&action=query&prop=extracts&explaintext&redirects=1&titles=$random_title")
    pageId=$(echo $json | jq '.query.pages | keys' | jq '.[0]')

    content=$(echo $json | python3 -c "import sys, json; print(json.load(sys.stdin)['query']['pages'][$pageId]['extract'])")
    content=$(echo $content | sed 's/\r$//')

    [[ "$1" == "verbose" ]] && echo "Content"
    [[ "$1" == "verbose" ]] && echo "=============="
    [[ "$1" == "verbose" ]] && echo "$content"

    #Write to CSV
    echo "\"$categories\",$content" >> $CSV_FILE_NAME
    
}

if ! [[ "$1" =~ ^[0-9]+$ ]];
then
    echo "You must pass a positive integer"
    exit 1
fi

for i in $(seq 1 "$1"); do 
    addNewArticleToCsv "$2"
    [[ "$2" != "verbose" ]] && echo "Article $i/$1"
done