cat >gateway_template.yaml <<EOM
AWSTemplateFormatVersion: 2010-09-09
Description: Lambda and API Gateway

Resources:
    RestApi:
        Type: 'AWS::ApiGateway::RestApi'
        Properties:
            Name: test_api

    testResource:
        Type: 'AWS::ApiGateway::Resource'
        Properties:
            RestApiId: !Ref RestApi
            ParentId: !GetAtt 
                - RestApi
                - RootResourceId
            PathPart: codepipeline_test

    testMethod:
        Type: 'AWS::ApiGateway::Method'
        Properties: 
            RestApiId: !Ref RestApi
            ResourceId: !Ref testResource
            HttpMethod: GET
            Integration:
                Type: AWS_PROXY
                IntegrationHttpMethod: POST
                Uri: !ImportValue 'testingArn'
                IntegrationResponses:
                    - ResponseTemplates:
                        application/json: ""
                      StatusCode: 200
                PassthroughBehavior: WHEN_NO_TEMPLATES
            MethodResponses:
                - StatusCode: 200
                  ResponseModels: { "application/json": "Empty" }     


    Deployment:
        Type: 'AWS::ApiGateway::Deployment'
        DependsOn: testMethod
        Properties:
            RestApiId: !Ref RestApi
            Description: TEST STAGE
            StageName: DEV
  

EOM

cat gateway_template.yaml