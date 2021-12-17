
cat >template.yaml <<EOM
AWSTemplateFormatVersion: '2010-09-09'
Transform: AWS::Serverless-2016-10-31
Resources:
  testing:
    Type: AWS::Serverless::Function
    Properties:
      FunctionName: codepipeline-test
      Handler: index.handler
      Runtime: nodejs14.x
      
      CodeUri: test123/
      AutoPublishAlias: default
      DeploymentPreference:
        Enabled: True
        Type: AllAtOnce
      MemorySize: 128
      Policies:
      - AWSLambdaBasicExecutionRole
      Timeout: 100

  ConfigLambdaPermission:
    Type: "AWS::Lambda::Permission"
    Properties:
      Action: lambda:InvokeFunction
      FunctionName: !Ref testing
      Principal: apigateway.amazonaws.com

Outputs:
  testingARN:
    Description: "testing ARN"
    Value: !Join
            - ''
            - - 'arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/'
              - !GetAtt testing.Arn
              - '/invocations'  
    Export:
      Name: testingArn
    
  
EOM
cat template.yaml
