import React, { useEffect, useState } from 'react'
import { Box, Typography } from '@mui/material'
import { tokens } from '../../theme';
import { Link, useLocation, useNavigate } from 'react-router-dom';
import { FaEye, FaEyeSlash } from 'react-icons/fa';

export default function EditMemberT() {
    const navigate = useNavigate();
    const location = useLocation();
    const data = location.state.data;
    const [id, setId] = useState(0);
    const [userName, setuserName] = useState('');
    const [firstName, setfirstName] = useState('');
    const [lastName, setlastName] = useState('');
    const [token, settoken] = useState(localStorage.getItem("token"))
   const [phone,setphone] = useState('')
    useEffect(() => {
        setId(data.id);
        setuserName(data.userName)
        setfirstName(data.firstName)
        setlastName(data.lastName)
        setphone(data.phoneNumber)
    }, [data.id, data.userName,data.firstName,data.lastName,data.phoneNumber]);

    const handlesubmit = (e) => {
        e.preventDefault();
        const empdata = {
            "id":id,
            "userName": userName,
            "firstName": firstName,
            "lastName":lastName,
            "phoneNumber":phone,
        }
        fetch("https://localhost:7245/Admin/v1/api/Users", {
            method: "PUT",
            headers: { "content-type": "application/json" },
            body: JSON.stringify(empdata)
        }).then((res) => {
            alert('Bạn muốn thay đổi thông tin')
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
                Thông tin nhân viên
            </Typography>
            <form onSubmit={handlesubmit}>
                <div style={{ "textAlign": "left" }}>

                    <div className="card-body">
                        <div className="row">
                            <div className="col-lg-12">
                                <div className="form-group">
                                    <label fontWeight="bold">Họ:</label>
                                    <input type="text" value={firstName} className="form-control" onChange={(e) => setfirstName(e.target.value)} required />
                                </div>
                            </div>
                            <div className="col-lg-12">
                                <div className="form-group">
                                    <label fontWeight="bold">Tên:</label>
                                    <input type="text" value={lastName} className="form-control" onChange={(e) => setlastName(e.target.value)} required />
                                </div>
                            </div>
                            <div className="col-lg-12">
                                <div className="form-group">
                                    <label fontWeight="bold">SDT:</label>
                                    <input  value={phone} type='number' className="form-control" onChange={(e) => setlastName(e.target.value)} required />
                                </div>
                            </div>
                        </div>
                        <div className="row">
                            <div className="col-lg-12">
                                <div className="form-group">
                                    <label fontWeight="bold">Tên đăng nhập:</label>
                                    <input type="text" value={userName} className="form-control" onChange={(e) => setuserName(e.target.value)} required />
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div style={{ margin: "20px 0" }} className='mx-3'>
                    <button type="submit" className="btn btn-primary">Lưu</button>
                    <Link to="/MrSoai/member" className="btn btn-danger" style={{ marginLeft: "20px" }}>Hủy</Link>
                </div>
            </form>
        </div>
    );
}