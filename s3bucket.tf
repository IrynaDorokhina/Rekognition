
resource "aws_s3_bucket" "images-2522" {
    bucket = "images-2522"
}

resource "aws_s3_bucket_public_access_block" "images-2522" {
    bucket = aws_s3_bucket.images-2522.id
    block_public_acls = false
    block_public_policy = false
}

resource "aws_s3_bucket_acl" "acl" {
    bucket = aws_s3_bucket.images-2522.id
    acl    = "public-read"
}

resource "aws_s3_bucket_policy" "allow_access" {
    bucket = aws_s3_bucket.images-2522.id
    policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::images-2522/*"
        }
    ]
}
POLICY
}