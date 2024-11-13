import React, {useState} from 'react';
import { NavBar } from '../navbar/NavBar';
import "./login.css";

export const Login = () => {
    const [buttonText, setButtonText] = useState("Don't have an Account?");
    const [showSignUpForm, setShowSignUpForm] = useState(false);

    const handleLogin = () => {
        //implementation for login
    }

    const handleSignUp = () => {
        //implementation for signup
    }

    const buttonClick = () => {
        setShowSignUpForm(!showSignUpForm);
        if (buttonText === "Don't have an Account?") {
            setButtonText("Log In?");
        } else {
            setButtonText("Don't have an Account?");
        }
    }

    return (
        <>
            <NavBar />
            {showSignUpForm ? 
            <>
                <form id="signupForm"
                name="signupForm"
                onSubmit={handleSignUp()}
                className="mainForm"
                >
                    <label className="inputLabel" htmlFor="username">Username: </label>
                    <input id="user" type="text" name="username" placeholder="username" />
                    <label className="inputLabel" htmlFor="pass">Password: </label>
                    <input id="pass" type="password" name="pass" placeholder="password" />
                    <label className="inputLabel" htmlFor="pass">Retype Password: </label>
                    <input id="pass2" type="password" name="pass2" placeholder="password" />
                    <div className="buttonContainer">
                        <input className="submitButton" type="submit" value="Sign up" />
                        <button className="submitButton" id="switchButton" onClick={buttonClick}>{buttonText}</button>
                    </div>
                </form>
            </>
            :
            <>
                <form id="loginForm"
                name="loginForm"
                onSubmit={handleLogin()}
                className="mainForm"
                >
                    <label className="inputLabel">Username: </label>
                    <input id="user" type="text" name="username" placeholder="username"/>
                    <label className="inputLabel">Password: </label>
                    <input id="pass" type="password" name="pass" placeholder="password"/>
                    <div className="buttonContainer">
                        <input className="submitButton" type="submit" value="Sign In" />
                        <button className="submitButton" id="switchButton" onClick={buttonClick}>{buttonText}</button>
                    </div>
                </form>
            </>
            }
        </>
    )
}