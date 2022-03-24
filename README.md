# wikipedia_scraper
Tool to get random articles from wikipedia and also the categories linked to the article and build a CSV file with this information.

## CSV data

| Column name      | Description |
| ----------- | ----------- |
| categories      | This column contains the categories of the article, including the article title       |
| content   | This column contain the article itself        |

## Execute scraper
./wikipedia_scraper n [verbose]

where n > 0, number of articles

### Examples
`./wikipedia_scraper 2`, Write two articles to the CSV file

`./wikipedia_scraper 2 verbose`, Same as before, but prints all the logs in the terminal
