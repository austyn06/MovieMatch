import { Amplify, Auth } from "aws-amplify";

const awsconfig = {
  Auth: {
    region: import.meta.env.VITE_AWS_REGION,
    userPoolId: import.meta.env.VITE_USER_POOL_ID,
    userPoolWebClientId: import.meta.env.VITE_USER_POOL_CLIENT_ID,
    oauth: {
      domain: import.meta.env.VITE_COGNITO_DOMAIN,
      scope: ["email", "openid", "profile"],
      redirectSignIn: import.meta.env.VITE_AMPLIFY_APP_URL,
      redirectSignOut: import.meta.env.VITE_AMPLIFY_APP_URL,
      responseType: "code",
    },
  },
  API: {
    endpoints: [
      {
        name: "MovieAPI",
        endpoint: import.meta.env.VITE_API_GATEWAY_URL,
        region: import.meta.env.VITE_AWS_REGION,
        custom_header: async () => {
          const session = await Auth.currentSession();
          const token = session.getIdToken().getJwtToken();
          return {
            Authorization: token,
          };
        },
      },
    ],
  },
};

Amplify.configure(awsconfig);

export default awsconfig;
