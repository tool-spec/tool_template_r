# Pull any base image that includes R
FROM r-base:latest

# Build spec binary from source (arm64 compatible)
RUN apt-get update && apt-get install -y golang-go git && \
    git clone https://github.com/hydrocode-de/gotap.git /tmp/gotap && \
    cd /tmp/gotap && go build -o /usr/local/bin/spec ./main.go && \
    rm -rf /tmp/gotap && \
    apt-get remove -y golang-go git && apt-get autoremove -y && apt-get clean

# install the latest version of json2aRgs from CRAN to parse parameters from /in/input.json
RUN R -e "install.packages('json2aRgs')"

# Do anything you need to install tool dependencies here
RUN echo "Replace this line with a tool"

# create the tool input structure
RUN mkdir /in
COPY ./in /in
RUN mkdir /out
RUN mkdir /src
COPY ./src /src

WORKDIR /src
CMD ["spec", "run", "foobar", "--input-file", "/in/input.json"]
