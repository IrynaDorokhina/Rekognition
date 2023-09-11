resource "aws_s3_bucket" "images-2522" {
bucket = "images-2522"
#prefix = "images"
    tags = {
        Name = "images-2522"
    }
}

resource "aws_s3_bucket_object" "object" {
  bucket = "images-2522"
  key    = "images/"
  #source = "/dev/null"
  acl    = "private"
}

resource "aws_s3_bucket_acl" "s3_bucket_acl" {
    bucket = aws_s3_bucket.images-2522.id
    acl = "private"
    depends_on = [ aws_s3_bucket_ownership_controls.s3_bucket_acl_ownership ]
}

# Resource to avoid error "AccessControlListNotSupported: The bucket does not allow ACLs"
resource "aws_s3_bucket_ownership_controls" "s3_bucket_acl_ownership" {
    bucket = aws_s3_bucket.images-2522.id
    rule {
        object_ownership = "ObjectWriter"    //BucketOwnerPreferred
    }
}