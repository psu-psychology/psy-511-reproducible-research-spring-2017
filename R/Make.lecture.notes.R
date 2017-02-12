Make.lecture.notes <- function(fn, 
                               fdir = "lecture-notes", 
                               all = TRUE, 
                               output_format = c("github_document", 
                                                 "pdf_document",
                                                 "ioslides_presentation")) {
  # Renders Rmd lecture notes
  #
  # Args:
  #   fn: RMarkdown file name
  #   fdir: Directory for lecture notes files, default is "lecture-notes"
  #   all: Boolean if TRUE, then print all *.Rmd files in fdir. Default is TRUE.
  #   output_format: Specifies the output formats to render. 
  #     Default is c("ioslides_presentation", "github_document", pdf_document"))
  #
  # Returns:
  #
  
  # History
  # 2017-02-03 rog added "github_document" to output formats.
  
  if (!all) {
    if (missing(fn)) {
      stop(sprintf("File must be specified.\n"))
    }
    if (!file.exists(paste(fdir, fn, sep="/"))) {
      stop(sprintf("File %s does not exist in directory %s.\n", fn, fdir))
    }
  }

  if (all) {
    rmd.list <- list.files(path = fdir, pattern = "\\.Rmd$", full.names = TRUE)
    lapply(rmd.list, rmarkdown::render, output_format = output_format)    
  } else {
    rmarkdown::render(input = paste(fdir, fn, sep="/"), 
                      output_format = output_format )
  }
}