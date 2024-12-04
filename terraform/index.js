exports.handler = (event, context, callback) => {
    // Automatically confirm the user
    event.response.autoConfirmUser = true;
    // Set email as verified
    event.response.autoVerifyEmail = true;
    
    // Return to Amazon Cognito
    callback(null, event);
};
