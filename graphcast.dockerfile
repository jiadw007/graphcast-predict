# Get ubuntu image from https://hub.docker.com/_/ubuntu.
FROM ubuntu:22.04

# Update ubuntu's package installer and download python and other important packages.
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get install -y python3 python3-pip curl unzip sudo
RUN sudo apt-get install -y libgeos-dev
# Download components required by Graphcast.
RUN pip3 install --upgrade https://github.com/deepmind/graphcast/archive/master.zip

# Create dashboard directory.
RUN mkdir -p /app
WORKDIR /app

# Copy all files to environment.
COPY . .

# Download necessary packages.

RUN pip3 uninstall -y shapely
RUN pip3 install -r requirements.txt
RUN pip3 install shapely --no-binary shapely
RUN pip3 install netcdf4
# RUN pip3 install -U "jax[cuda12_pip]" -f "https://storage.googleapis.com/jax-releases/jax_cuda_releases.html"
RUN pip install --upgrade pip
RUN pip install --upgrade "jax[cuda12_pip]" -f https://storage.googleapis.com/jax-releases/jax_cuda_releases.html
RUN pip install numpy==1.26.4

# Move the CDS key to the root folder.
RUN touch /app/.cdsapirc
RUN echo 'url: https://cds.climate.copernicus.eu/api' >> /app/.cdsapirc
RUN echo 'key: 54011b38-735f-44cf-9375-89288f53a00d' >> /app/.cdsapirc
RUN mv /app/.cdsapirc /root/.cdsapirc