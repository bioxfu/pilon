### Pilon Correction Workflow
#### Install Pilon
```
## https://github.com/broadinstitute/pilon/releases
cd ~
mkdir pilon
wget https://github.com/broadinstitute/pilon/releases/download/v1.22/pilon-1.22.jar
java -jar pilon-1.22.jar --help
```

#### Initiate the project
```
cp example/init.sh init.sh
# edit and run init.sh file according to your project
. init.sh
```

#### Run the workflow
```
nohup ./workflow.sh &
```
