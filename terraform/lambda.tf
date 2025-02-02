# IAM Role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "instance_management_lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# IAM Policy for Lambda
resource "aws_iam_role_policy" "lambda_policy" {
  name = "instance_management_lambda_policy"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:DescribeInstances",
          "ec2:StopInstances",
          "ec2:TerminateInstances"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

# Lambda Function for Stopping Instances
resource "aws_lambda_function" "stop_instances" {
  filename         = "lambda/lambda_function.zip"
  function_name    = "stop_instances_scheduled"
  role            = aws_iam_role.lambda_role.arn
  handler         = "stop_handler.handler"
  runtime         = "nodejs16.x"
  timeout         = 30

  environment {
    variables = {
      REGION = var.aws_region
    }
  }

  tags = {
    Name = "AutoStop"
  }
}

# CloudWatch Event Rule for Stop
resource "aws_cloudwatch_event_rule" "stop_instances" {
  name                = "stop-instances-evening"
  description         = "Automatically stop instances every evening at 20:00 UTC"
  schedule_expression = "cron(0 20 * * ? *)"
}

# CloudWatch Event Target for Stop
resource "aws_cloudwatch_event_target" "stop_instances" {
  rule      = aws_cloudwatch_event_rule.stop_instances.name
  target_id = "StopEC2Instances"
  arn       = aws_lambda_function.stop_instances.arn
}