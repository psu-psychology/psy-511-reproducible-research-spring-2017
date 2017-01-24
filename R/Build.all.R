# Build.all.R
# Builds entire course website

source("R/Make.lecture.notes.R")

# Render lecture notes
Make.lecture.notes(fdir = "lecture-notes")

# Render in-class activities
Make.lecture.notes(fdir = "in-class-activities")

# Render the site (copies files to docs/)
rmarkdown::render_site(encoding = "utf8")
