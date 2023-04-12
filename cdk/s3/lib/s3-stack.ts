import * as cdk from 'aws-cdk-lib';
import { Construct } from 'constructs';
import * as s3 from 'aws-cdk-lib/aws-s3';
import * as iam from 'aws-cdk-lib/aws-iam';

export class S3Stack extends cdk.Stack {
  constructor(scope: Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props);

    const user = new iam.User(this, 'User', {
      userName: 's3-user',
    });

    const s3_bucket = new s3.Bucket(this, 'S3Bucket', {
      bucketName: 'testbucket2z56d8gdt',
      blockPublicAccess: s3.BlockPublicAccess.BLOCK_ALL,
      removalPolicy: cdk.RemovalPolicy.DESTROY,
      intelligentTieringConfigurations: [
        {
          name: 'intelligent-tiering-configuration-all-objects',
          archiveAccessTierTime: cdk.Duration.days(90),
          deepArchiveAccessTierTime: cdk.Duration.days(180),
        },
      ],
    });

    s3_bucket.grantWrite(user);
    s3_bucket.grantRead(user);
  }
}
