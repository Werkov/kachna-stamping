FROM ubuntu:16.04

MAINTAINER Kachna

WORKDIR /stamping

# Install dependencies
RUN apt-get update && \
    apt-get install -y build-essential texlive-xetex pdftk pdfjam xpdf bc && \
    apt-get autoremove -y && \
    apt-get clean

# Copy all necessary files and folders
COPY Makefile layout-single.sh prepare-sample.sh process-single.sh process.sh ./
COPY sample-data sample-data/
COPY stamps stamps/
COPY utils utils/
COPY work work/

CMD make
