# This script updates the local git repo, commits it, and pushes to
# the remote server

system(command = "git add README.md")

# Update selected files in docs/
system(command = "git add docs/*.html")
system(command = "git add docs/bib docs/css docs/img docs/R")
system(command = "git add docs/lecture-notes/*html docs/lecture-notes/*.pdf docs/lecture-notes/*.Rmd")
system(command = "git add docs/in-class-activities/*html docs/in-class-activities/*.pdf docs/in-class-activities/*.Rmd")
system(command = "git add docs/in-class-activities/csv docs/in-class-activities/rmd-templates")
system(command = "git add docs/video")

# Update selected raw (mostly *.Rmd) files since .html and .pdf get re-rendered
system(command = "git add lecture-notes/*.Rmd")
system(command = "git add in-class-activities/*.Rmd")
system(command = "git add bib/ css/ img/ R/")

# Commit to local repo with date/timestamp message
commit.msg <- sprintf("'Update %s'", Sys.time())
system(command = sprintf("git commit -m %s", commit.msg))

# Push to remote branch (GitHub)
system(command = "git push origin master")