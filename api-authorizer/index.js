const jwt = require('jsonwebtoken');
exports.handler = async (event,callback) => {
    // TODO implement

    let response = {
        "principalId": null, 
        "policyDocument": {
          "Version": "2012-10-17",
          "Statement": [
            {
              "Action": "execute-api:Invoke",
              "Effect": "Deny",
              "Resource": "*",
            }]
        }
      };

    let verified = jwt.verify(token, 'secret-key', function(err, decoded) {
        if(err){
            console.log(err); 
            return false
        }

       if(validateEmail(decoded.email)){
            response = {
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
            return true
        }  
 });
    if(!verified)
    {
        callback("Unauthorized")
        return
    }
    return response;
};

const validateEmail = (email) => {
  return email.match(
    /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
  );
};
