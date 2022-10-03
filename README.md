# qumulo-scripts

## Qumulo_Replication.ps1
Gets current replication partners and returns length of replication tasks so PRTG could be used to alert on long running jobs. Max long running for an alert is currently hard coded

## QumuloCheck.ps1
Gets current replication partners and returns any errors encountered during replication 


## Setup
the scripts should be placed into folder recomended by PRTG
https://www.paessler.com/manuals/prtg/exe_script_sensor
The login information also needs to be placed in a folder on the windows server for PRTG to read. At the time I created this there was not a better way, may be better ways to pass authentication data into a custom sensor with newer versions of PRTG
