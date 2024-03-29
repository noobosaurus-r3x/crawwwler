# Web Crawler Bash Script

This script is a simple web crawler written in Bash. It takes a URL as an argument, downloads the HTML of the page, extracts all the links, and checks the HTTP status code for each link. It then prints the URL and its HTTP status code, with URLs returning a 200 status code highlighted in green and all others in red.

### Usage :

```./crawler.sh -u URL```

Replace URL with the website you want to crawl.

The results are saved in a text file named results_<URL>.txt, where <URL> is the URL argument with special characters replaced by underscores.

### Example :

```./crawler.sh -u https://noobosaurusr3x.fr```

This will download the HTML from https://noobosaurusr3x.fr, extract all the links, check their HTTP status codes, and save the results in a file named results_https_noobosaurusr3x_fr.txt.
