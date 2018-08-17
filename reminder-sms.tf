provider "aws" {
  region = "ap-southeast-2"
}

resource "aws_iam_role" "role" {
  name = "reminder-sms-lambda_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "policy" {
  name = "reminder-sms-lambda_policy"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "arn:aws:logs:*:*:*"
        },
        {
            "Effect": "Allow",
            "Action": "sns:*",
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "role_policy_attachment" {
  role       = "${aws_iam_role.role.name}"
  policy_arn = "${aws_iam_policy.policy.arn}"
}

resource "aws_lambda_function" "lambda_function" {
  filename         = "reminder-sms-lambda_payload.zip"
  function_name    = "reminder-sms-lambda_function"
  role             = "${aws_iam_role.role.arn}"
  handler          = "reminder-sms.lambda_handler"
  source_code_hash = "${base64sha256(file("reminder-sms-lambda_payload.zip"))}"
  runtime          = "python3.6"
}

resource "aws_cloudwatch_event_rule" "cloudwatch_event_rule" {
  name                = "2200_utc10"
  schedule_expression = "cron(0 12 * * ? *)"
}

resource "aws_cloudwatch_event_target" "cloudwatch_event_target" {
  rule      = "${aws_cloudwatch_event_rule.cloudwatch_event_rule.name}"
  target_id = "check_foo"
  arn       = "${aws_lambda_function.lambda_function.arn}"
}

resource "aws_lambda_permission" "lambda_permission" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.lambda_function.function_name}"
  principal     = "events.amazonaws.com"
  source_arn    = "${aws_cloudwatch_event_rule.cloudwatch_event_rule.arn}"
}
