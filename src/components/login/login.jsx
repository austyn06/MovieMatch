import React from 'react';
import { NavBar } from '../navbar/NavBar';
import { Amplify} from 'aws-amplify';
import { Authenticator, useAuthenticator } from '@aws-amplify/ui-react';
import '@aws-amplify/ui-react/styles.css';
import "./login.css";

Amplify.configure({
        region: 'us-east-1',
        userPoolId: 'us-east-1_fNBa2g3Gs', 
        userPoolWebClientId: '10gn06qn308vmrse43j6obkrts', 
});

export const Login = () => {
    // const { signOut, user } = useAuthenticator(context => [context.user]);

    return (
        <Authenticator>
            {({ signOut, user }) => (
                <>
                    <NavBar />
                    <div className="login-container">
                        {user ? (
                            <div>
                                <h3>Welcome, {user.username}</h3>
                                <button onClick={signOut}>Sign Out</button>
                            </div>
                        ) : (
                            <div>
                                <h3>Please sign in to access your account</h3>
                                <Authenticator.SignIn />
                            </div>
                        )}
                    </div>
                </>
            )}
        </Authenticator>
    );
};
