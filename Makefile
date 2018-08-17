all: build

.PHONY: build plan apply clean

build:
	zip reminder-sms-lambda_payload.zip reminder-sms.py

plan:
	terraform plan

apply:
	terraform apply

clean:
	rm -rf reminder-sms-lambda_payload.zip
