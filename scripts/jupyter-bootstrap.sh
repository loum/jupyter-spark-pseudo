#!/bin/sh

nohup sh -c /spark-bootstrap.sh &

# Check if PyPI packages need to be installed.
if [ -f /requirements.txt ]; then
    pip install --no-cache --requirement /requirements.txt
fi

# Start the Zeppelin server.
PYSPARK_DRIVER_PYTHON=/home/hdfs/.local/bin/jupyter\
 PYSPARK_DRIVER_PYTHON_OPTS="notebook\
 --no-browser\
 --ip 0.0.0.0\
 --notebook-dir=/home/hdfs/notebooks/\
 --port=$JUPYTER_PORT"\
 /opt/spark/bin/pyspark

# Block until we signal exit.
trap 'exit 0' TERM
while true; do sleep 0.5; done
