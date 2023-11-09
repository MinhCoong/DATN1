import React, { useEffect, useState } from 'react'
import { Box, Typography } from '@mui/material'
import { tokens } from '../../theme';
import { Link, useLocation, useNavigate } from 'react-router-dom';
import { FaEye, FaEyeSlash } from 'react-icons/fa';

export default function EditMember() {
    const navigate = useNavigate();
    const location = useLocation();
    const data = location.state.data;
    const [id, setId] = useState(0);
    const [userName, setuserName] = useState('');
    const [password, setpassword] = useState('');
    const [token,settoken] = useState(localStorage.getItem("token"))
    const [showPassword, setShowPassword] = useState(false);
    const [showConfirm, setShowConfirm] = useState(false);
    const [confirmError, setConfirmError] = useState(false);
    const [passwordError, setPasswordError] = useState(false);
    const [confirm, setconfirm] = useState('');
    const passwordRegex = /^(?=.*[A-Z])(?=.*[!@#$%^&])(?=.*[0-9]).{8,}$/; 
    const [saveDisabled, setSaveDisabled] = useState(true);
    useEffect(() => {
        setId(data.id);
        setuserName(data.userName)      
    }, [data.id,data.userName]);
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
    const handlesubmit = (e) => {
        e.preventDefault();
        const empdata = {
            "userName": userName,
            "password": password,
        }
        fetch("https://localhost:7245/Admin/v1/api/Users/reset-password/" + id, {
            method: "POST",
            headers: { "content-type": "application/json"},
            body: JSON.stringify(empdata)
        }).then((res) => {
            alert('Bạn đả thay đổi mật khẩu')
            navigate('/MrSoai/member');
        }).catch((err) => {
            console.log(err.message)
        })
    }
    return (
        <div>
            <Typography
                variant="h2"
                fontWeight="bold"
                sx={{ m: " 0 10px 5px 20px" }}
            >
                Thay đổi mật khẩu Nhân viên
            </Typography>
            <form onSubmit={handlesubmit}>
                <div style={{ "textAlign": "left" }}>

                    <div className="card-body">
                        <div className="row">
                            <div className="col-lg-12">
                                <div className="form-group">
                                    <label fontWeight="bold">Tên đăng nhập:</label>
                                    <input type="text" value={userName} className="form-control" onChange={(e) => setuserName(e.target.value)} required />
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
                    <Link to="/MrSoai/member" className="btn btn-danger"    style={{ marginLeft: "20px" }}>Hủy</Link>
                </div>
            </form>
        </div>
    );
}