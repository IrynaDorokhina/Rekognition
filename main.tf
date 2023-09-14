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
    role = aws_iam_role.lambda_role.arn
    handler = "index.lambda_handler"
    runtime = "python3.9"
    depends_on = [aws_iam_role_policy_attachment.attach_policy1]
}

resource "aws_s3_bucket_notification" "trigger" {
    bucket = "images-2522"
    lambda_function {
        lambda_function_arn = aws_lambda_function.lambdafun.arn
        events              = ["s3:ObjectCreated:*"]
    }
    depends_on = [aws_lambda_permission.s3_lambda_permission]
}

resource "aws_lambda_permission" "s3_lambda_permission" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambdafun.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.images-2522.arn
}

resource "aws_lambda_permission" "apigw_lambda_permission" {
    statement_id  = "AllowExecutionFromAPIGateway"
    action        = "lambda:InvokeFunction"
    function_name = aws_lambda_function.lambdafun.arn
    principal     = "apigateway.amazonaws.com"
    source_arn = "arn:aws:execute-api:us-east-1::aws_api_gateway_rest_api.api.id/*/aws_api_gateway_method.method.http_method/aws_api_gateway_resource.resource.path"
}