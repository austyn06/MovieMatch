import React from "react";
import { useNavigate } from "react-router-dom";
// import { Amplify} from 'aws-amplify';
// import { Authenticator, useAuthenticator } from '@aws-amplify/ui-react';
// import '@aws-amplify/ui-react/styles.css';
import "./login.css";
// import awsConfig from '../../aws-exports';

// Amplify.configure(awsConfig);

export const Login = () => {
  // const { signOut, user } = useAuthenticator(context => [context.user]);
  const navigate = useNavigate();

  return (
    // <Authenticator>
    //     {({ signOut, user }) => (
    //         <>
    //             <NavBar />
    //             <div className="login-container">
    //                 {user ? (
    //                     <div>
    //                         <h3>Welcome, {user.username}</h3>
    //                         <button onClick={signOut}>Sign Out</button>
    //                     </div>
    //                 ) : (
    //                     <div>
    //                         <h3>Please sign in to access your account</h3>
    //                         <Authenticator.SignIn />
    //                     </div>
    //                 )}
    //             </div>
    //         </>
    //     )}
    // </Authenticator>
    <div>
      <div className="center">
        <h1>Login Page</h1>
      </div>
    </div>
  );
};
