# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
#FROM jupyter/scipy-notebook
FROM dddlab/base-scipy:sha-2116205

USER root

# REQUIREMENT FOR RCLONE
RUN apt-get update -y && \
    apt-get install -y fuse
# INSTALL RCLONE
RUN apt-get update && \
    curl --silent -L --fail https://github.com/rclone/rclone/releases/download/v1.53.1/rclone-v1.53.1-linux-amd64.deb > /tmp/rclone.deb && \
    apt-get install -y /tmp/rclone.deb && \
    rm /tmp/rclone.deb && \
    apt-get clean && rm -rf /var/lib/apt/kists/*
 
LABEL maintainer="Patrick Windmiller <sysadmin@pstat.ucsb.edu>"

USER $NB_UID

RUN pip install datascience

# Install spaCy, pandas, scikit-learn packages
RUN conda install -c conda-forge spacy && \
    conda install --quiet -y pandas && \
    conda install --quiet -y scikit-learn && \
    conda clean -tipsy && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER
