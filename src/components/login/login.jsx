import React, { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import { Amplify, Auth } from 'aws-amplify';
import { Authenticator } from '@aws-amplify/ui-react';
import '@aws-amplify/ui-react/styles.css';
import "./login.css";
import awsConfig from '../../amplifyConfig';

Amplify.configure(awsConfig);

export const Login = () => {
  const navigate = useNavigate();
  const [authState, setAuthState] = useState('signIn');

  useEffect(() => {
    const checkUser = async () => {
      try {
        const user = await Auth.currentAuthenticatedUser();
        if (user) {
          navigate("/movies");
          window.location.reload();
        }
      } catch (error) {
        setAuthState("signIn");
      }
    };

    checkUser();
  }, [navigate]);

  const handleAuthStateChange = (nextAuthState) => {
    if (nextAuthState === 'signedIn') {
      navigate("/movies");
      window.location.reload();
    }
    setAuthState(nextAuthState);
  };

  return (
    <div className="login-page">
      <Authenticator 
        onStateChange={handleAuthStateChange}
        authState={authState}
      >
        {({ signOut, user }) => (
          <div style={{ textAlign: 'center', marginTop: '20px' }}>
            <h1 className="login-title">Welcome to MovieMatch!</h1>
            {user && (
              <div className="movies-button"
                onClick={() => {
                  navigate('/movies');
                }}
              >
                Go to Movies
              </div>
            )}
          </div>
        )}
      </Authenticator>
    </div>
  );
};
