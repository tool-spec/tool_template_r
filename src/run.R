# load gotap-generated parameter bindings
source("parameters.R")

result <- get_parameters()
params <- result$parameters
data <- result$data

toolname <- tolower(Sys.getenv("TOOL_RUN", "foobar"))
if (toolname == "") {
  toolname <- "foobar"
}

if (toolname == "foobar") {
  print("You have tried to run the tool 'foobar'.
This tool is the template tool without any functionality.
Please implement another tool or select the tool you
have already implemented.")
  print(params)
  print(data)
} else {
  print(paste("[", Sys.time(), "] Either no TOOL_RUN environment variable available, or '", toolname, "' is not valid.\n", sep = ""))
}
