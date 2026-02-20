# Build gotap from source, then discard Go
FROM golang:1.25-alpine AS gotap-builder
RUN apk add --no-cache git
ARG GOTAP_VERSION=main
RUN git clone --depth 1 --branch ${GOTAP_VERSION} https://github.com/tool-spec/gotap.git /gotap && \
    cd /gotap && go build -o gotap .

# Pull any base image that includes R
FROM r-base:4.2.0
COPY --from=gotap-builder /gotap/gotap /usr/local/bin/gotap
RUN chmod +x /usr/local/bin/gotap

# install jsonlite for gotap R bindings
RUN R -e "install.packages('jsonlite', repos='https://cloud.r-project.org')"

# Do anything you need to install tool dependencies here
RUN echo "Replace this line with a tool"

# create the tool input structure
RUN mkdir /in
COPY ./in /in
RUN mkdir /out
RUN mkdir /src
COPY ./src /src

WORKDIR /src

# Generate parameter bindings from tool.yml at build time
RUN gotap generate --spec-file=tool.yml --target=r --output=parameters.R

# copy the citation file - looks funny to make COPY not fail if the file is not there
COPY ./CITATION.cf[f] /src/CITATION.cff

WORKDIR /src
CMD ["gotap", "run", "foobar", "--input-file", "/in/input.json"]
