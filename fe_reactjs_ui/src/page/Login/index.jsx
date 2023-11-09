import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import './style.css'
import { FaEye, FaEyeSlash } from 'react-icons/fa';

function Login() {
    const navigate = useNavigate();
    const [username, setusername] = useState("");
    const [password, setpassword] = useState("");
    const [showPassword, setShowPassword] = useState(false);
    const [loginError, setLoginError] = useState(false);

    const handleShowPassword = () => {
        setShowPassword(!showPassword);
    }

    const handlesubmit = (e) => {
        e.preventDefault();

        const empdata = { username, password };
        fetch("https://localhost:7245/v1/api/Authenticate/Login", {
            method: "POST",
            headers: { "content-type": "application/json" },
            body: JSON.stringify(empdata)
        }).then(res => res.json()).then(res => {
            let token = res.token;
            let role = res.role;
            let userId = res.id
            console.log(userId);
            localStorage.setItem("token", token);
            localStorage.setItem("userId", userId)
            if (role === "Staff") {
                navigate("/MrSoai/home")
            }
            else if (role === "Admin") {
                navigate("/MrSoai/")
            }
            else {
                setLoginError(true);
            }
        }).catch((err) => {
            console.log(err.message)
            setLoginError(true);
        })

    }

    return (
        <div className='bodycolor'>
            <div className="center">
                <h1>Login</h1>
                <form method="post" onSubmit={handlesubmit}>
                    <div className="txt_field">
                        <input value={username} onChange={e => setusername(e.target.value)} type="text" required />
                        <span></span>
                        <label>Tên người dùng</label>
                    </div>
                    <div className="txt_field d-flex">
                        <input value={password} onChange={e => setpassword(e.target.value)} type={showPassword ? "text" : "password"} required />
                        <span></span>
                        <label>Mật khẩu</label>
                        <div className="pass-icon" onClick={handleShowPassword}>
                            {showPassword ? <FaEyeSlash /> : <FaEye />}
                        </div>
                    </div>
                    {loginError && <p className="error-message" >Tên người dùng hoặc mật khẩu không đúng</p>}
                    <input type="submit" value="Login" />
                    <div className="signup_link">
                        Chào mừng bạn
                    </div>
                </form>
            </div>
        </div>
    );
}

export default Login;