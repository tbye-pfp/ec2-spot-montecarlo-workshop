#!/bin/bash
	# Install Dependencies
	yum -y install git python-numpy python-matplotlib python-scipy
	pip install pandas-datareader fix_yahoo_finance
	pip install scipy 
	pip install boto3
	
	#Populate Variables
    echo 'Populating Variables'
	REGION=`curl http://169.254.169.254/latest/dynamic/instance-identity/document|grep region|awk -F\" '{print $4}'`
	mkdir /home/ec2-user/spotlabworker
	chown ec2-user:ec2-user /home/ec2-user/spotlabworker
	cd /home/ec2-user/spotlabworker
	WEBURL=$(aws cloudformation --region $REGION describe-stacks --query 'Stacks[0].Outputs[?OutputKey==`WebInterface`].OutputValue' --output text)
	echo 'Region is '$REGION
    echo 'URL is '$WEBURL

    echo "Downloading worker code"
	wget $WEBURL/static/queue_processor.py
	wget $WEBURL/static/worker.py
	
	echo 'Starting the worker processor'
	python /home/ec2-user/spotlabworker/queue_processor.py --region $REGION> stdout.txt 2>&1