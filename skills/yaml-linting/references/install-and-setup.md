# Setup & Installation

Get Docker and yamllint ready for use.

## Prerequisites

- Docker installed and running
- Basic familiarity with Docker commands

## Pulling the Image

The `pipelinecomponents/yamllint` image is maintained by the pipelinecomponents organization and
is available on Docker Hub.

```bash
# Pull the latest yamllint image
docker pull pipelinecomponents/yamllint
```

First run may take a moment as Docker downloads the image (~100 MB).

## Verifying Installation

Check that the image is available and yamllint works:

```bash
# Verify yamllint responds
docker run --rm pipelinecomponents/yamllint yamllint --version
```

Expected output: `yamllint X.Y.Z` where X.Y.Z is the version number.

## Next Steps

- Run `docker run --rm -v "$(pwd):/data" pipelinecomponents/yamllint yamllint .` to lint a directory
- Create a `.yamllint` config file in your project root for custom rules
- See Quick Reference for common flags and patterns
