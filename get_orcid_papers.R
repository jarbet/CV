library(rorcid);
library(RefManageR);

orcid.id <- '0000-0003-4218-2458';

# Get your works
works <- orcid_works(orcid.id);

dois <- sapply(
    X = 1:nrow(works[[1]]$works),
    FUN = function(x) {
        works[[1]]$works$`external-ids.external-id`[[x]]$`external-id-value`[ works[[1]]$works$`external-ids.external-id`[[x]]$`external-id-type` == 'doi'];    }
    );

# Get BibTeX from Crossref using RefManageR
bib <- GetBibEntryWithDOI(dois)

# Save as .bib
WriteBib(bib, file = 'jaron_published_orcid.bib')