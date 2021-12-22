exports.handler = async (event) => {
    // TODO implement
    
    const response = {
        "principalId": "apigateway.amazonaws.com",
        "policyDocument": {
            "Version": "2012-10-17",
            "Statement": [{
                "Action": "execute-api:Invoke",
                "Effect": "Allow",
                "Resource": event.methodArn
            }]
        }
    };
    return response;
};
