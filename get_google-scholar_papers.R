# Replace with your actual Google Scholar ID
my_id <- "hbqQUw0AAAAJ"
publications <- get_publications(my_id)
publications$url <- get_article_scholar_url(
    id = my_id,
    pubid = publications$pubid
    );

# Function to convert publication to BibTeX entry
convert_to_bibtex <- function(publication) {
    bib_entry <- paste0(
        "@article{", publication$cid, ",\n",
        "  author = {", publication$author, "},\n",
        "  title = {", publication$title, "},\n",
        "  journal = {", publication$journal, "},\n",
        "  year = {", publication$year, "},\n",
        "  number = {", publication$number, "},\n",
        "  url = {\\href{", publication$url,"}{URL}},\n"
    )
    
    # Close the entry
    bib_entry <- paste0(bib_entry, "}\n")
    
    return(bib_entry)
}

# Create a list of BibTeX entries
bibtex_entries <- sapply(1:nrow(publications), function(i) {
    convert_to_bibtex(publications[i, ])
})

# Join all entries into a single string
bibtex_string <- paste(bibtex_entries, collapse = "\n")

# Write to a .bib file
writeLines(bibtex_string, "jaron_published.bib")
