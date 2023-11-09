import React from 'react'
import { Box, Typography, useTheme, } from '@mui/material'
import { tokens } from '../../theme';
import { Link, useNavigate } from 'react-router-dom';
import { useEffect, useState } from "react";
import { FaEye, FaEyeSlash } from 'react-icons/fa';

export default function CreateMember() {
    const theme = useTheme();
    const colors = tokens(theme.palette.mode);
    const navigate = useNavigate();
    const [firstName, setfirstName] = useState('');
    const [lastName, setlastName] = useState('');
    const [phone, setphone] = useState('');
    const [userName, setuserName] = useState('');
    const [password, setpassword] = useState('');
    const [confirm, setconfirm] = useState('');
    const [role, setrole] = useState("staff");
    const [showPassword, setShowPassword] = useState(false);
    const [showConfirm, setShowConfirm] = useState(false);
    const [confirmError, setConfirmError] = useState(false);
    const [saveDisabled, setSaveDisabled] = useState(true); // Thêm biến state
    const [passwordError, setPasswordError] = useState(false);
    const [token, settoken] = useState(localStorage.getItem("token"))
    const handlesubmit = (e) => {
        e.preventDefault();
        const empdata = {
            "firstName": firstName,
            "lastName": lastName,
            "phoneNumber": phone,
            "userName": userName,
            "password": password,
            "confirmPassword": confirm
        }
        fetch("https://localhost:7245/v1/api/Authenticate/RegisterAdmin/" + role, {
            method: "POST",
            headers: { "content-type": "application/json", 'Authorization': `Bearer ${token}` },
            body: JSON.stringify(empdata)
        }).then((res) => {
            alert('Bạn muốn thêm nhân viên')
            navigate('/MrSoai/member');
        }).catch((err) => {
            console.log(err.message)
        })
    }

    const handleChange = (event) => {
        setrole(event.target.value);
    }

    const handleShowPassword = () => {
        setShowPassword(!showPassword);
    }

    const handleShowConfirm = () => {
        setShowConfirm(!showConfirm);
    }

    const handleConfirmChange = (event) => {
        setconfirm(event.target.value);
        if (event.target.value !== password) {
            setConfirmError(true);
            setSaveDisabled(true); // Disable nút Save nếu có lỗi
        } else {
            setConfirmError(false);
            setSaveDisabled(passwordError); // Enable nút Save nếu không có lỗi
        }
    }

    const passwordRegex = /^(?=.*[A-Z])(?=.*[!@#$%^&])(?=.*[0-9]).{8,}$/; // Định dạng mật khẩu
    const handlePasswordChange = (event) => {
        setpassword(event.target.value);
        if (!passwordRegex.test(event.target.value)) { // Kiểm tra mật khẩu đúng định dạng
            setPasswordError(true);
            setSaveDisabled(true);
        } else {
            setPasswordError(false);
            setSaveDisabled(confirmError); // Enable nút Save nếu không có lỗi
        }
    }
    const [phoneError, setPhoneError] = useState("");

    const handleChangePhone = (event) => {
        const input = event.target.value;
        if (input.length < 10 || input.length > 10) {
            setPhoneError("Số điện thoại phải đúng 10 chữ số");
        } else {
            setPhoneError("");
            setphone(input);
        }
    }
    return (
        <div>
            <Typography
                variant="h2"
                fontWeight="bold"
                sx={{ m: " 0 10px 5px 20px" }}
            >
                Thêm tài khoản
            </Typography>
            <form onSubmit={handlesubmit}>
                <div style={{ "textAlign": "left" }}>

                    <div className="card-body">
                        <div className="row">
                            <div className="col-lg-12">
                                <div className="form-group">
                                    <label fontWeight="bold">Chọn quyền: </label>
                                    <select value={role} onChange={handleChange}>
                                        <option value={'staff'}>staff</option>
                                        <option value={'admin'}>admin</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div className="row">
                            <div className="col-lg-12">
                                <div className="form-group">
                                    <label fontWeight="bold">Họ:</label>
                                    <input  type="text" className="form-control" onChange={(e) => setfirstName(e.target.value)} required />
                                </div>
                            </div>
                            <div className="col-lg-12">
                                <div className="form-group">
                                    <label fontWeight="bold">Tên:</label>
                                    <input  type="text" className="form-control" onChange={(e) => setlastName(e.target.value)} required />
                                </div>
                            </div>
                        </div>
                        <div className="row">
                            <div className="col-lg-12">
                                <div className="form-group">
                                    <label fontWeight="bold">Số điện thoại:</label>
                                    <input type="number" className="form-control" onKeyPress={(event) => {
                                        if (!/[0-9]/.test(event.key)) {
                                            event.preventDefault();
                                        }
                                    }} onChange={handleChangePhone} required />
                                    {phoneError && <span style={{ color: "red" }}>{phoneError}</span>}
                                </div>
                            </div>
                            <div className="col-lg-12">
                                <div className="form-group">
                                    <label fontWeight="bold">Tên đăng nhập:</label>
                                    <input type="text" className="form-control" onChange={(e) => setuserName(e.target.value)} required />
                                </div>
                            </div>
                        </div>
                        <div className="row">
                            <div className="col-lg-12">
                                <div className="form-group">
                                    <label fontWeight="bold">Mật khẩu:</label>
                                    <div className="input-group">
                                        <input type={showPassword ? 'text' : 'password'} className="form-control" onChange={handlePasswordChange} required />
                                        <button type="button" className="btn btn-outline-secondary" onClick={handleShowPassword}>
                                            {showPassword ? <FaEyeSlash /> : <FaEye />}
                                        </button>
                                    </div>
                                    {passwordError && <Box color="error.main">Mật khẩu phải có ít nhất 8 kí tự, bao gồm chữ hoa, kí tự đặc biệt và số</Box>}
                                </div>
                            </div>
                            <div className="col-lg-12">
                                <div className="form-group">
                                    <label fontWeight="bold">Xác nhận mật khẩu:</label>
                                    <div className="input-group">
                                        <input type={showConfirm ? 'text' : 'password'} className="form-control" onChange={handleConfirmChange} required />
                                        <button type="button" className="btn btn-outline-secondary" onClick={handleShowConfirm}>
                                            {showConfirm ? <FaEyeSlash /> : <FaEye />}
                                        </button>
                                    </div>
                                    {confirmError && <Box color="error.main">Mật khẩu và xác nhận mật khẩu không khớp</Box>}
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div style={{ margin: "20px 0" }} className='mx-3'>
                    <button type="submit" disabled={saveDisabled} className="btn btn-primary">Lưu</button>
                    <Link to="/MrSoai/member" className="btn btn-danger" style={{ marginLeft: "20px" }}>Hủy</Link>
                </div>
            </form>
        </div>
    )
}