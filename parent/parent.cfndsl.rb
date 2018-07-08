CloudFormation do

  S3_Bucket(:parentDefinedBucket) do

  end


  if conditionalbucket
    S3_Bucket(:iExistWithCondition) do
    end
  end

  if conditionalbucket2
    S3_Bucket(:iExistWithCondition2) do
    end
  end

  EC2_Instance(:applicationInstance) do
    ImageId 'ami-97785bed'
  end

end