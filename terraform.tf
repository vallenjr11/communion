# AWS region
provider "aws" {
  region = "us-east-1"
}


# Input variable for S3 bucket name
variable "bucket_name" {
  description = "Name of the S3 bucket"
  default     = "phonenumberss3bucket" # "www.communionstudio.com"   Default bucket name: fix idompotency
}

# S3 bucket holding Webpage
resource "aws_s3_bucket" "phone_numbers_s3" {
  bucket = var.bucket_name
}

# Define the S3 bucket policy explicitly
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.phone_numbers_s3.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "PublicRead",
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = [
          "arn:aws:s3:::${aws_s3_bucket.phone_numbers_s3.id}",
          "arn:aws:s3:::${aws_s3_bucket.phone_numbers_s3.id}/*"  
        ]
      }
    ]
  })

    #Dependency on the aws_s3_bucket resource
    depends_on = [aws_s3_bucket.phone_numbers_s3] #Possible race condition? DEBUG

}

resource "aws_s3_bucket_ownership_controls" "communion_bucket_owner" {
  bucket = aws_s3_bucket.phone_numbers_s3.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

#Configuration to for s3 to host as webpage
resource "aws_s3_bucket_website_configuration" "communion_s3_static_web_config" {
  bucket = aws_s3_bucket.phone_numbers_s3.id
  
  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "error.html"
  }
}

# Define public access settings
resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket = aws_s3_bucket.phone_numbers_s3.id

  block_public_acls       = true
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}


# DynamoDB holding PhoneNumbers
resource "aws_dynamodb_table" "phonenumbers_create_db" {
  name         = "PhoneNumbersTest"
  billing_mode = "PROVISIONED"

# Provisioned capacity settings
 read_capacity  = 1 
 write_capacity = 1
  
  # Primary key attributes
  hash_key = "phone_number"

  attribute {
    name = "phone_number"
    type = "S"
  }
 
}

# Lambda function to PUT phoneNumber in DB
resource "aws_lambda_function" "lambda_put_phonenumbers_db" {
  function_name = "Lambda_PUT_PhoneNumbers"
  runtime      = "python3.11"
  handler      = "lambda_function.lambda_handler"
  role         = "arn:aws:iam::014321940013:role/service-role/collectPhoneNumbers-role-ely2nrrz"

  # ZIP file containing Lambda function code
  filename = "lambda/lambda_function.zip" #this will change in prod
}
