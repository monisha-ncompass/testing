
cat >auth_template.yaml <<EOM
AWSTemplateFormatVersion: '2010-09-09'
Transform: AWS::Serverless-2016-10-31
Resources:
  apiAuthorizer:
    Type: AWS::Serverless::Function
    Properties:
      FunctionName: test-authorizer
      Handler: index.handler
      Runtime: nodejs14.x
      
      CodeUri: api-authorizer/
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
      FunctionName: !Ref apiAuthorizer
      Principal: apigateway.amazonaws.com

Outputs:
  apiAuthorizerARN:
    Description: "apiAuthorizer ARN"
    Value: !Join
            - ''
            - - 'arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/'
              - !GetAtt apiAuthorizer.Arn
              - '/invocations'  
    Export:
      Name: apiAuthorizerArn
    
  
EOM
cat auth_template.yaml
