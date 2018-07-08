CloudFormation do

  S3_Bucket(:childDefinedBucket) do

  end


  EC2_Instance(:applicationInstance) do
    # override AMI to AWS Linux 2 in us-east-1 with
    ImageId 'ami-7105540e'
    InstanceType application_instance_type
  end

end