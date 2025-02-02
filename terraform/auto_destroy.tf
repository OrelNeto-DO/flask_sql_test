# CloudWatch Event Rule for Destroy
resource "aws_cloudwatch_event_rule" "auto_destroy" {
  name                = "auto-destroy-after-3h"
  description         = "Auto destroy all resources after 3 hours"
  schedule_expression = "rate(3 hours)"
}

# CloudWatch Event Target for Destroy
resource "aws_cloudwatch_event_target" "auto_destroy" {
  rule      = aws_cloudwatch_event_rule.auto_destroy.name
  target_id = "AutoDestroyTarget"
  arn       = aws_lambda_function.auto_destroy.arn
}

# Lambda Function for Destroying Instances
resource "aws_lambda_function" "auto_destroy" {
  filename      = "lambda/lambda_function.zip"
  function_name = "auto_destroy_resources"
  role          = aws_iam_role.lambda_role.arn
  handler       = "destroy_handler.handler"
  runtime       = "nodejs16.x"
  timeout       = 900

  environment {
    variables = {
      REGION = var.aws_region
    }
  }

  tags = {
    Name = "AutoDestroy"
  }
}