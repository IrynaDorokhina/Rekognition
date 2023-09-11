provider "aws" {
    region = "us-east-1"
}
 
data "archive_file" "zip_the_python_code" {
    type = "zip"
    source_dir = "${path.module}/python/"
    output_path = "${path.module}/python/python.zip"
}

resource "aws_lambda_function" "lambdafun" {
    function_name = "lambdafun"
    filename = "${path.module}/python/python.zip"
    #filename = "${path.module}/python/index.py"
    role = aws_iam_role.lambda_role.arn
    handler = "index.lambda_handler"
    runtime = "python3.9"
    depends_on = [aws_iam_role_policy_attachment.attach_policy1]
}

resource "aws_lambda_function" "lambdas3" {
    function_name = "lambdas3"
    filename = "${path.module}/python/python.zip"
    #filename = "${path.module}/python/s3upload.py"
    role = aws_iam_role.lambda_role.arn
    handler = "s3upload.lambda_handler"
    runtime = "python3.9"
    depends_on = [aws_iam_role_policy_attachment.attach_policy1]
}