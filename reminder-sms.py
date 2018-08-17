#!/usr/bin/env python3

import boto3

SENDER_ID = 'GRIMACE'
PHONE_NUMBER = '+61418123456'
MESSAGE = 'Hello, World!'

def send_reminder():
    client = boto3.client('sns')

    client.set_sms_attributes(
        attributes={
            'DefaultSenderID': SENDER_ID
        }
    )

    client.publish(
        PhoneNumber=PHONE_NUMBER,
        Message=MESSAGE
    )

def lambda_handler(event, context):
    send_reminder()

if __name__ == "__main__":
    send_reminder()
