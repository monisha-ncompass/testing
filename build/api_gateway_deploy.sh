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

    OptionsMethod:
        Type: AWS::ApiGateway::Method
        Properties:
            AuthorizationType: NONE
            RestApiId: !Ref RestApi
            ResourceId:
                Ref: testResource
            HttpMethod: OPTIONS
            Integration:
                IntegrationResponses:
                    - StatusCode: 200
                      ResponseParameters:
                        method.response.header.Access-Control-Allow-Headers: "'username,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
                        method.response.header.Access-Control-Allow-Methods: "'GET,POST,PUT,DELETE,OPTIONS'"
                        method.response.header.Access-Control-Allow-Origin: "'*'"
                      ResponseTemplates:
                        application/json: ''
                PassthroughBehavior: WHEN_NO_MATCH
                RequestTemplates:
                    application/json: '{"statusCode": 200}'
                Type: MOCK
            MethodResponses:
                - StatusCode: 200
                  ResponseModels:
                    application/json: 'Empty'
                  ResponseParameters:
                    method.response.header.Access-Control-Allow-Headers: false
                    method.response.header.Access-Control-Allow-Methods: false
                    method.response.header.Access-Control-Allow-Origin: false
                
    testMethod:
        Type: 'AWS::ApiGateway::Method'
        Properties: 
            RestApiId: !Ref RestApi
            ResourceId: !Ref testResource
            HttpMethod: GET
            AuthorizationType: NONE
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
    
    putMethod:
        Type: 'AWS::ApiGateway::Method'
        Properties: 
            RestApiId: !Ref RestApi
            ResourceId: !Ref testResource
            HttpMethod: PUT
            AuthorizationType: NONE
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
        DependsOn: testResource
        Properties:
            RestApiId: !Ref RestApi
            Description: TEST STAGE
            StageName: DEV

EOM

cat gateway_template.yaml