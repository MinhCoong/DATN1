import { useEffect, useState } from "react";
import { Link, useNavigate } from "react-router-dom";
import { Typography } from '@mui/material'
import Select from 'react-select';
import axios from "axios";
import './create.css';

export default function CreateCoupon() {
    const [id] = useState(0);
    const [title, setTitle] = useState("");
    const [startDate, setstartDate] = useState("");
    const [endDate, setendDate] = useState("");
    const [code, setcode] = useState("");
    const [discount, setdiscount] = useState("");
    const [point, setpoint] = useState("");
    const [minimumQuantity, setminimumQuantity] = useState("");
    const [minimumTotla, setminimumTotla] = useState("");
    const [description, setdescription] = useState("");
    const [user, setuser] = useState("");
    const [selectedOption, setSelectedOption] = useState(null);
    const navigate = useNavigate();
    const [imageFile, setImageFile] = useState(null);
    const [imageUrl, setImageUrl] = useState("");
    const [token,settoken] = useState(localStorage.getItem("token"))
    const handleImageChange = (event) => {
        setImageFile(event.target.files[0]);
        setImageUrl(URL.createObjectURL(event.target.files[0]));
    };
    const [userId,setuserId] = useState(localStorage.getItem("userId"))

    const handleSubmit = (e) => {
        e.preventDefault();
        const formData = new FormData();

        formData.append('id', id)
        formData.append('imageFile', imageFile);
        formData.append('title', title)
        formData.append('description', description)
        formData.append('userId', userId)
        formData.append('user.Id', userId)
        formData.append('startDate', startDate)
        formData.append('endDate', endDate)
        formData.append('code', code)
        formData.append('discount', discount)
        formData.append('point', point)
        formData.append('minimumQuantity', minimumQuantity)
        formData.append('minimumTotla', minimumTotla)
        fetch("https://localhost:7245/Admin/v1/api/coupon", {
            method: "POST",
            body: formData,
             headers: { 'Authorization': `Bearer ${token}`}
        }).then((res) => {
            alert('Bạn muốn thêm mã khuyến mãi')
            navigate('/MrSoai/coupon');
        }).catch((err) => {
            console.log(err.message)
        })

    }
    useEffect(() => {
        axios.get("https://localhost:7245/Admin/v1/api/user",{ headers: { 'Authorization': `Bearer ${token}`}})
            .then(response => {
                const user = response.data.map(item => ({
                    value: item.id,
                    label: item.userName
                }));
                setuser(user);
            })
            .catch(error => {
                console.error(error);
            });
    }, []);
    const handleSelectChange = selectedOption => {
        setSelectedOption(selectedOption);
    };

    return (
        <div>
            <Typography
                variant="h2"
                fontWeight="bold"
                sx={{ m: " 0 10px 5px 20px" }}
            >
                Thêm mã khuyến mãi
            </Typography>
            <form onSubmit={handleSubmit}>
                <div style={{ "textAlign": "left" }}>
                    <div className="card-body">
                        <div className="row" >

                            {/* <div className="col-lg-6">
                                <div className="form-group">
                                    <label fontWeight="bold">Nhân viên</label>
                                    <Select
                                        options={user}
                                        value={selectedOption}
                                        onChange={handleSelectChange}
                                        className="text"
                                    />
                                </div>
                            </div> */}
                            <div className="col-lg-6">
                                <div className="form-group">
                                    <label fontWeight="bold">Tiêu đề</label>
                                    <input required value={title} onChange={e => setTitle(e.target.value)} className="form-control"></input>
                                </div>
                            </div>
                            <div className="col-lg-6">
                                <div className="form-group">
                                    <label fontWeight="bold">Điểm</label>
                                    <input required type="number" value={point} onChange={e => setpoint(e.target.value)} className="form-control"></input>
                                </div>
                            </div>
                            <div className="col-lg-6">
                                <div className="form-group">
                                    <label fontWeight="bold">Mã</label>
                                    <input required value={code} onChange={e => setcode(e.target.value)} className="form-control"></input>
                                </div>
                            </div>
                            <div className="col-lg-6">
                                <div className="form-group">
                                    <label fontWeight="bold">Ghi chú</label>
                                    <input required value={description} onChange={e => setdescription(e.target.value)} className="form-control"></input>
                                </div>
                            </div>
                            <div className="col-lg-6">
                                <div className="form-group">
                                    <label fontWeight="bold">Giảm giá</label>
                                    <input required type="number" value={discount} onChange={e => setdiscount(e.target.value)} className="form-control"></input>
                                </div>
                            </div>
                        </div>
                       <div className="row" >
                            <div className="col-lg-6">
                                <div className="form-group">
                                    <label fontWeight="bold">Ngày bắt đầu</label>
                                    <input required type="date" value={startDate} onChange={e => setstartDate(e.target.value)} className="form-control"></input>
                                </div>
                            </div>
                            <div className="col-lg-6">
                                <div className="form-group">
                                    <label fontWeight="bold">Ngày kết thúc</label>
                                    <input required type="date" value={endDate} onChange={e => setendDate(e.target.value)} className="form-control"></input>
                                </div>
                            </div>
                            

                            <div className="col-lg-6">
                                <div className="form-group">
                                    <label fontWeight="bold">Số lượng tối thiểu</label>
                                    <input required type="number" value={minimumQuantity} onChange={e => setminimumQuantity(e.target.value)} className="form-control"></input>
                                </div>
                            </div>


                            <div className="col-lg-6">
                                <div className="form-group">
                                    <label fontWeight="bold">Tối đa giảm giá</label>
                                    <input required type="number" value={minimumTotla} onChange={e => setminimumTotla(e.target.value)} className="form-control"></input>
                                </div>
                            </div>
                            <div className="col-lg-6 mt-4">
                                {imageUrl && <img src={imageUrl} alt="Selected file" width="80px" height="80px" />}
                                <div className="form-group">
                                    <label htmlFor="imageFile" >Chọn hình ảnh:</label>
                                    <input required type="file" id="imageFile" className="px-3" onChange={handleImageChange} />
                                </div>
                            </div>

                        </div>

                        <div className="col-lg-6 d-flex flex-row mt-4">
                            <div className="form-group  ">
                                <button className="btn btn-success" type="submit">Lưu</button>
                            </div>
                            <div className="form-group  mx-4">
                                <Link to="/MrSoai/coupon" className="btn btn-danger">Thoát</Link>
                            </div>
                        </div>
                    </div>
                </div>
            </form>
        </div>
    );
}