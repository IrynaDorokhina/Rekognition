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

/*resource "aws_lambda_function" "lambdas3" {
    function_name = "lambdas3"
    filename = "${path.module}/python/python.zip"
    #filename = "${path.module}/python/s3upload.py"
    role = aws_iam_role.lambda_role.arn
    handler = "s3upload.lambda_handler"
    runtime = "python3.9"
    depends_on = [aws_iam_role_policy_attachment.attach_policy1]
}*/

resource "aws_s3_bucket_notification" "trigger" {
    bucket = "images-2522"
    lambda_function {
        lambda_function_arn = aws_lambda_function.lambdafun.arn
        events              = ["s3:ObjectCreated:*"]
        filter_prefix       = "images/"
    }
}

resource "aws_lambda_permission" "s3_lambda_permission" {
    statement_id  = "AllowS3Invoke"
    action        = "lambda:InvokeFunction"
    function_name = aws_lambda_function.lambdafun.arn
    principal = "s3.amazonaws.com"
    source_arn = "arn:aws:s3:::images-2522"
}

resource "aws_lambda_permission" "apigw_lambda_permission" {
    statement_id  = "AllowExecutionFromAPIGateway"
    action        = "lambda:InvokeFunction"
    function_name = aws_lambda_function.lambdafun.arn
    principal     = "apigateway.amazonaws.com"
    source_arn = "arn:aws:execute-api:us-east-1::aws_api_gateway_rest_api.api.id/*/aws_api_gateway_method.method.http_methodaws_api_gateway_resource.resource.path"
}