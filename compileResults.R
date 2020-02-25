require("data.table")

# If we're on mac, set the path to dropbox as in /Users/Devin/ and the github
# path as in /Users/Devin/Documents else set dropPath in windows to E:/
if(.Platform$OS.type == "unix") {
  dropPath = file.path("", "Users", "Devin")
  gitPath = file.path("", "Users", "Devin", "Documents")
} else if (.Platform$OS.type == "windows") {
  dropPath = file.path("E:")
}

# Add on the dropbox file structure to dropPath
dropPath = file.path(dropPath, "Dropbox (Brain Energy Lab)", "Everything")

# If we're on window set gitPath to being within dropPath in the Devin folder
if(.Platform$OS.type == "windows") {
  gitPath = file.path(dropPath, "Devin")
}

# Add GitHub to the gitPath
gitPath = file.path(gitPath, "GitHub")

fileLocs = 
  list.files(path = file.path(dropPath, "Laura", "Immuno", "Isolectin"), 
             pattern = "IB4Overlap.csv", full.names = T, recursive = T, ignore.case = T)

out = rbindlist(lapply(fileLocs, function(x) {
  temp = fread(x, header = T)
  temp[, c("Mouse", "Image") := list(basename(dirname(dirname(dirname(x)))), basename(dirname(x)))]
  return(temp)
}))

out = out[complete.cases(out)]
fwrite(out, file = file.path(dropPath, "Laura", "Immuno", "Isolectin", "Results.csv"))