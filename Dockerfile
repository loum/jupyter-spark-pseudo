# syntax=docker/dockerfile:1.4

ARG JUPYTER_VERSION
ARG SPARK_PSEUDO_BASE_IMAGE

ARG SPARK_PSEUDO_BASE_IMAGE
FROM $SPARK_PSEUDO_BASE_IMAGE as main

# Run everything as JUPYTER_USER
ARG JUPYTER_USER=hdfs
ARG JUPYTER_GROUP=hdfs
ARG JUPYTER_HOME=/home/hdfs

COPY scripts/jupyter-bootstrap.sh /jupyter-bootstrap.sh

WORKDIR $JUPYTER_HOME

WORKDIR $JUPYTER_HOME/.local
RUN chown -R $JUPYTER_USER:$JUPYTER_GROUP $JUPYTER_HOME/.local

# YARN ResourceManager port.
EXPOSE 8032

# YARN ResourceManager webapp port.
EXPOSE 8088

# YARN NodeManager webapp port.
EXPOSE 8042

# Spark HistoryServer web UI port.
EXPOSE 18080
ARG JUPYTER_PORT=8889
EXPOSE $JUPYTER_PORT

WORKDIR $JUPYTER_HOME
USER $JUPYTER_USER
ENV PATH "$PATH:$JUPYTER_HOME/.local/bin"

ARG JUPYTER_VERSION
RUN python -m pip install\
 --no-cache-dir\
 --user\
 notebook==$JUPYTER_VERSION

ENTRYPOINT [ "/jupyter-bootstrap.sh" ]
CMD = []
