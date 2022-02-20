#!/bin/sh

nohup sh -c /spark-bootstrap.sh &

counter=0
sleep_time=5
break_out=50
file_to_check="/opt/spark/conf/spark-env.sh"
while : ; do
    if [ -f "$file_to_check" ] || [ $counter -gt $break_out ]
    then
        if [ -f "$file_to_check" ]
        then
            echo "### $file_to_check create complete"
        else
            echo "### ERROR: $file_to_check timeout"
        fi
        break
    else
        echo "### $0 pausing until $file_to_check exists."
        sleep $sleep_time
        counter=$((counter+1))
    fi
done

# Check if PyPI packages need to be installed.
if [ -f /requirements.txt ]; then
    pip install --no-cache --requirement /requirements.txt
fi

# Start the Jupyter server.
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
