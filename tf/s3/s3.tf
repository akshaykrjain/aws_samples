resource "aws_s3_bucket" "bucket" {
  bucket_prefix = "created-with-terraform"
}


resource "aws_s3_bucket_intelligent_tiering_configuration" "entire-bucket" {
  bucket = aws_s3_bucket.bucket.bucket
  name   = "EntireBucket"

  tiering {
    access_tier = "DEEP_ARCHIVE_ACCESS"
    days        = 180
  }
  tiering {
    access_tier = "ARCHIVE_ACCESS"
    days        = 125
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "intelligent" {
  bucket = aws_s3_bucket.bucket.id

  rule {
    id = "transition_all_object_to_INTELLIGENT_TIERING"

    transition {
      days          = 7
      storage_class = "INTELLIGENT_TIERING"
    }

    status = "Enabled"
  }
}


