# Build.all.R
# Builds entire course website

source("R/Make.lecture.notes.R")

# Render lecture notes
Make.lecture.notes(fdir = "lecture-notes")

# Render in-class activities
Make.lecture.notes(fdir = "in-class-activities")

rmarkdown::render_site(encoding = "utf8")