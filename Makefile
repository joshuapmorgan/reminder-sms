all: build

.PHONY: build
build:
	zip reminder-sms-lambda_payload.zip reminder-sms.py

plan:
	terraform plan

apply:
	terraform apply

clean:
	rm -rf reminder-sms-lambda_payload.zip
