#!/bin/bash

# Get CPU usage
cpu_usage=$(top -l 1 | grep "CPU usage" | awk '{print $3}')

# Get memory usage
memory_usage=$(top -l 1 | grep PhysMem | awk '{print $6}')

# Output results
echo "<result>CPU Usage: $cpu_usage, Memory Usage: $memory_usage</result>"
