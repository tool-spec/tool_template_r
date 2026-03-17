# tool_template_r

[![Docker Image CI](https://github.com/tool-spec/tool_template_r/actions/workflows/docker-image.yml/badge.svg)](https://github.com/tool-spec/tool_template_r/actions/workflows/docker-image.yml)
[![DOI](https://zenodo.org/badge/558418032.svg)](https://doi.org/10.5281/zenodo.7372629)

Template repository for building an R tool that follows the [Tool Specification](https://tool-spec.github.io/tool-specs/) container contract.

## How `gotap` works here

This template installs [`gotap`](https://github.com/tool-spec/gotap) inside the image and uses it as the default runtime shim:

```Dockerfile
CMD ["gotap", "run", "foobar", "--input-file", "/in/input.json"]
```

At build time, `gotap generate` creates `parameters.R` from `src/tool.yml`. At runtime, `run.R` uses the generated bindings to validate `/in/input.json`, load parameters and data paths, and write structured run logs.

## Required file structure

```text
/
|- in/
|  |- input.json
|- out/
|  |- ...
|- src/
|  |- tool.yml
|  |- run.R
|  |- parameters.R   (generated at build time)
|  |- CITATION.cff
```

## Build and run

Build the image from the template root:

```bash
docker build -t tbr_r_template .
```

Run the sample tool:

```bash
docker run --rm -it \
  -v "$(pwd)/in:/in" \
  -v "$(pwd)/out:/out" \
  -e TOOL_RUN=foobar \
  tbr_r_template
```

`TOOL_RUN` is only needed when the image contains more than one tool entry.

## Customize

1. Update `src/tool.yml` to describe your tool.
2. Add R or system dependencies in `Dockerfile`.
3. Implement your tool logic in `src/run.R`.
4. Rebuild the image so `gotap generate` refreshes `parameters.R`.

## Generated bindings and logging

The generated `parameters.R` file is not edited by hand. It exposes:

- `get_parameters()`
- `get_run_context()`
- `get_logger()`

The starter runtime uses `get_logger()` for structured JSON Lines logging and keeps the sample parsed input visible on standard output.
