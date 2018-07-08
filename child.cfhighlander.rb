CfhighlanderTemplate do

  Extends 'parent'

  Parameters do

    ComponentParam 'childParamToBeUsed'
    ComponentParam 'parentParamToBeOverwritten', type: 'AWS::EC2::Subnet::Id'

  end

end