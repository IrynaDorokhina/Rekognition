resource "aws_dynamodb_table" "ImageLabels" {
    name = "ImageLabels"
    billing_mode = "PROVISIONED"
    read_capacity= "5"
    write_capacity= "5"
    attribute {
        name = "Image"
        type = "S"
    }
    hash_key = "Image"
}