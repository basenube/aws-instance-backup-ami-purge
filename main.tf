/*
  baseNUBE 
  Ron Sweeney, 2019.
  This plan includes the creation of the following AWS Resources:
  -- Lambda Function: Backup of Instances with the tag of "Backup"
  -- Lambda Function: Deletion of Created AMI's from Backup with a DeleteOn of the specified time duration in days.
  -- ExecutionRole: Shared by both functions.
  -- Shceduled Rule: Trigger for Backup function.
  -- Scheduled Rule: Trigger for purge function.
  -- Lambda Permissions(2): Permission to Invoke Respective Lamba Functions. 
*/

# Variables
variable "tf_key" {
  description = "This is the plan identifier through out the resources created so we can created more than just one by changing this variable"
  default = "basenube"
}

# Datas
data "archive_file" "lambda_backup" { 
  type = "zip"
  source_file = "backup.py"
  output_path = "backup.zip"
}

data "archive_file" "lambda_purge" { 
  type = "zip"
  source_file = "purge.py"
  output_path = "purge.zip"
}

# Configure the AWS Provider
provider "aws" {
  //However You Do This
  //access_key = "${var.aws_access_key}"
  //secret_key = "${var.aws_secret_key}"
  region     = "us-east-1"
}

resource "aws_lambda_function" "instancebackup" {
  function_name = "${lower(var.tf_key)}-instance-backup"
  role = "${aws_iam_role.lambda_exec.arn}"
  filename = "${data.archive_file.lambda_backup.output_path}"
  handler = "backup.lambda_handler"
  runtime = "python2.7"
  source_code_hash = "${base64sha256(file(data.archive_file.lambda_backup.output_path))}"
  environment {
      variables =
      {
          TFKEY = "${var.tf_key}"
      }
  }
}

resource "aws_lambda_function" "imagepurge" {
  function_name = "${lower(var.tf_key)}-image-purge"
  role = "${aws_iam_role.lambda_exec.arn}"
  filename = "${data.archive_file.lambda_purge.output_path}"
  handler = "purge.lambda_handler"
  runtime = "python2.7"
  source_code_hash = "${base64sha256(file(data.archive_file.lambda_purge.output_path))}"
  environment {
    variables =
      {
          TFKEY = "${var.tf_key}"
      }
  }
}

resource "aws_iam_role" "lambda_exec" {
  name = "${var.tf_key}_instance_backup_purge_ami"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "ec2:*"
            ],
            "Resource": "*",
            "Effect": "Allow"
        }
    ]
}
EOF
}

resource "aws_cloudwatch_event_rule" "sched_backup_event" {
  name                = "${var.tf_key}_instance_backup"
  description         = "Backup instances nightly"
  schedule_expression = "cron(0 0 * * ? *)"
}

resource "aws_cloudwatch_event_target" "sched_backup_event_target" {
  rule      = "${aws_cloudwatch_event_rule.sched_backup_event.name}"
  target_id = "${var.tf_key}_instance_backup"
  arn       = "${aws_lambda_function.instancebackup.arn}"
}

resource "aws_cloudwatch_event_rule" "sched_purge_event" {
  name                = "${var.tf_key}_image_purge"
  description         = "Purge ami's and volumes nightly"
  schedule_expression = "cron(0 0 * * ? *)"
}

resource "aws_cloudwatch_event_target" "sched_purge_event_target" {
  rule      = "${aws_cloudwatch_event_rule.sched_purge_event.name}"
  target_id = "${var.tf_key}_image_purge"
  arn       = "${aws_lambda_function.imagepurge.arn}"
}







