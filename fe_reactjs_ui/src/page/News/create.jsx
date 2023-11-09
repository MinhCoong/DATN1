import { useEffect, useState } from "react";
import { Link, useNavigate } from "react-router-dom";
import { Typography } from '@mui/material'
import Select from 'react-select';
import axios from "axios";
import './create.css';

export default function CreateNews() {
    const [id] = useState(0);
    const [title, setTitle] = useState("");
    const [newsDate, setnewsDate] = useState("");
    const [description, setdescription] = useState("");
    const [user, setuser] = useState("");
    const [selectedOption, setSelectedOption] = useState("user");
    const [validation, setValidation] = useState(false);
    const navigate = useNavigate();
    const [imageFile, setImageFile] = useState(null);
    const [imageUrl, setImageUrl] = useState("");
    const handleImageChange = (event) => {
        setImageFile(event.target.files[0]);
        setImageUrl(URL.createObjectURL(event.target.files[0]));
    };
    const [token,settoken] = useState(localStorage.getItem("token"))
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
        formData.append('newsDate',newsDate)
        fetch("https://localhost:7245/Admin/v1/api/news", {
            method: "POST",
            body: formData,
            headers: { 'Authorization': `Bearer ${token}`}
        }).then((res) => {
            alert('Bạn muốn thêm tin tức')
            navigate('/MrSoai/news');
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
                Thêm tin tức
            </Typography>
            <form onSubmit={handleSubmit}>
                <div style={{ "textAlign": "left" }}>

                    <div className="card-body">
                        <div className="row">

                        {/* <div className="col-lg-12">
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
                            <div className="col-lg-12">
                                <div className="form-group">
                                    <label fontWeight="bold">Tiêu đề</label>
                                    <input required value={title}  onChange={e => setTitle(e.target.value)} className="form-control"></input>
                                    {title.length === 0 && validation && <span className="text-danger">Enter the name</span>}
                                </div>
                            </div>
                            <div className="col-lg-12">
                                <div className="form-group">
                                    <label fontWeight="bold">Ngày lập</label>
                                    <input required type="date" value={newsDate} onMouseDown={e => setValidation(true)} onChange={e => setnewsDate(e.target.value)} className="form-control"></input>
                                </div>
                            </div>
                            <div className="col-lg-12">
                                <div className="form-group">
                                    <label fontWeight="bold">Ghi chú</label>
                                    <input required value={description} onMouseDown={e => setValidation(true)} onChange={e => setdescription(e.target.value)} className="form-control"></input>
                                </div>
                            </div>


                            <div className="col-lg-12">
                            {imageUrl && <img src={imageUrl} alt="Selected file" width="80px" height="80px"/>}
                                <div className="form-group">
                                    <label htmlFor="imageFile">Chọn hình ảnh:</label>
                                    <input required type="file" id="imageFile" onChange={handleImageChange} />
                                </div>
                            </div>

                            <div className="col-lg-12 d-flex flex-row mt-4">
                                <div className="form-group">
                                    <button className="btn btn-success" type="submit">Lưu</button>
                                    
                                </div>
                                <div className="mx-3">
                                <Link to="/MrSoai/news" className="btn btn-danger">Thoát</Link>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </form>
        </div>
    );
}