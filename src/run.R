# load gotap-generated parameter bindings
source("parameters.R")

result <- get_parameters()
params <- result$parameters
data <- result$data
logger <- get_logger()

toolname <- tolower(Sys.getenv("TOOL_RUN", "foobar"))
if (toolname == "") {
  toolname <- "foobar"
}

logger$info("start", "Starting tool run", tool = toolname)
logger$info(
  "input-loaded",
  "Loaded validated parameters and data paths",
  tool = toolname,
  parameter_count = length(params),
  data_keys = sort(names(data))
)

if (toolname == "foobar") {
  print("You have tried to run the tool 'foobar'.
This tool is the template tool without any functionality.
Please implement another tool or select the tool you
have already implemented.")
  print(params)
  print(data)
  logger$info("finished", "Template run finished successfully", tool = toolname)
} else {
  logger$error("error", "Requested tool is not implemented in the template", tool = toolname)
  stop(paste("Either no TOOL_RUN environment variable available, or '", toolname, "' is not valid.\n", sep = ""))
}
