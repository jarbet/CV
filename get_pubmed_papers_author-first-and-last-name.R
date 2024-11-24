library(rentrez)
library(xml2)
library(RefManageR)
library(dplyr)

# Search for articles by Jaron Arbet in PubMed
search_results <- entrez_search(db="pubmed", term="Jaron Arbet[Author]", retmax=100)

# Extract the list of PubMed IDs (PMIDs)
pmids <- search_results$ids

# Function to get full metadata from PubMed
# Function to get full metadata from PubMed
get_metadata_from_pubmed <- function(pmid) {
    # Query PubMed using the PMID
    record <- entrez_fetch(db="pubmed", id=pmid, rettype="xml")
    
    # Parse the XML record
    xml_data <- xml2::read_xml(record)
    
    # Extract DOI if available
    doi <- xml_data %>%
        xml_find_first(".//ArticleId[@IdType='doi']") %>%
        xml_text()
    
    # Extract other metadata (authors, title, journal, etc.)
    title <- xml_data %>%
        xml_find_first(".//ArticleTitle") %>%
        xml_text()
    
    # Extract authors' first and last names
    authors <- xml_data %>%
        xml_find_all(".//Author") %>%
        purrr::map_chr(~ {
            first_name <- xml2::xml_find_first(.x, ".//ForeName") %>%
                xml_text()
            last_name <- xml2::xml_find_first(.x, ".//LastName") %>%
                xml_text()
            # Combine first and last names
            paste(first_name, last_name)
        }) %>%
        paste(collapse = ", ")  # Combine all authors into a single string
    
    journal <- xml_data %>%
        xml_find_first(".//Journal/Title") %>%
        xml_text()
    
    year <- xml_data %>%
        xml_find_first(".//PubDate/Year") %>%
        xml_text()
    
    # If year is missing, use "Unknown" or try other fields like PubDate
    if (is.na(year) || year == "") {
        # Try to get the year from other sources, e.g., DOI or fallback
        if (is.na(doi) || doi == "") {
            year <- "Unknown"
        } else {
            # This can be further enhanced by extracting year from the DOI metadata, if applicable
            year <- "Unknown"  # Use a default value if DOI is not helpful
        }
    }
    
    volume <- xml_data %>%
        xml_find_first(".//Volume") %>%
        xml_text()
    
    pages <- xml_data %>%
        xml_find_first(".//MedlineCitation/Article/Pages") %>%
        xml_text()
    
    # Return all extracted metadata
    list(
        title = title,
        authors = authors,
        journal = journal,
        year = year,
        volume = volume,
        pages = pages,
        doi = doi
    )
}


# Extract metadata for each PMID
metadata_list <- lapply(pmids, get_metadata_from_pubmed)

# Print the extracted metadata for each paper
metadata_list

######## convert to .bib file
create_bib_entry <- function(pmid, metadata) {
    authors <- gsub(',', ' and',metadata$authors)
    bib_entry <- paste0(
        "@article{", pmid, ",\n",
        "  author = {", authors, "},\n",
        "  title = {", metadata$title, "},\n",
        "  journal = {", metadata$journal, "},\n",
        "  year = {", metadata$year, "},\n",
        "  doi = {", metadata$doi, "}\n",
        "}\n"
    )
    return(bib_entry)
}

# Generate the .bib entries for each article
bib_entries <- mapply(create_bib_entry, pmids, metadata_list)

# Write the .bib entries to a .bib file
writeLines(bib_entries, "jaron_published_author-first-and-last-name.bib")
