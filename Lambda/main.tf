resource "aws_iam_role" "example" {
  name = "lambda_execution_role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action"    : "sts:AssumeRole",
        "Effect"    : "Allow",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_lambda_function" "lambda_function" {
    function_name = var.lambda_name
    filename      = "/g:/IAMOPS/Filuet/IaC/Lambda/${var.file_name}"
    source_code_hash = filebase64sha256("/g:/IAMOPS/Filuet/IaC/Lambda/${var.file_name}")
    handler       = "lambda_function.handler"

    runtime       = "python3.8"

    role          = aws_iam_role.example.arn

# tags = {
#     Name = "LEMBDAA"
# }
}

