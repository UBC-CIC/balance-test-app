// This is sample code. Please update this to suite your schema
const AWS = require("aws-sdk");
const cognitoIdentity = new AWS.CognitoIdentity();
const cognito = new AWS.CognitoIdentityServiceProvider();
const jwt = require("jsonwebtoken");

/**
 * @type {import('@types/aws-lambda').APIGatewayProxyHandler}
 */
exports.handler = async (event) => {
  console.log(`EVENT: ${JSON.stringify(event)}`);
  const {
    authorizationToken,
    requestContext: {
      variables: { patient_id },
    },
  } = event;
  // let token = authorizationToken.replace("prefix-", "");

  const user_cognito_id = jwt.decode(authorizationToken).sub;
  let params = {
    // todo: remove hard-coded value
    UserPoolId: "ca-central-1_qBJ3I7w8V",
    Username: user_cognito_id,
  };
  let getUserResponse = await cognito.adminGetUser(params).promise();
  let user = getUserResponse.UserAttributes;
  console.log("user", user);
  let identityId;
  let isCareProvider = false;
  for (let i = 0; i < user.length; i++) {
    if (user[i].Name == "custom:identity_id") {
      identityId = "ca-central-1:" + user[i].Value;
    }
    if (user[i].Name == "custom:user_type") {
      console.log("user[i]", user[i]);
      isCareProvider = true;
    }
  }
  console.log("identityId", identityId);
  console.log("patient_id", patient_id);
  console.log("iscareprovider", isCareProvider);

  const response = {
    isAuthorized: isCareProvider || patient_id === identityId,
    // resolverContext: {
    //   userid: "user-id",
    //   info: "contextual information A",
    //   more_info: "contextual information B",
    // },
    // deniedFields: [
    //   `arn:aws:appsync:${process.env.AWS_REGION}:${accountId}:apis/${apiId}/types/Event/fields/comments`,
    //   `Mutation.createEvent`,
    // ],
    ttlOverride: 300,
  };
  console.log(`response >`, JSON.stringify(response, null, 2));
  return response;
};
