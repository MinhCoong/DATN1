import { useEffect, useState } from "react";
import { Link, useLocation, useNavigate } from "react-router-dom";
import { Typography } from '@mui/material'
import Select from 'react-select';
import axios from "axios";
import './create.css';

export default function EditNews() {
    const location = useLocation();
    const data = location.state.data;
    const [id, setId] = useState(0);
    const [title, setTitle] = useState("");
    const [newsDate, setnewsDate] = useState("");
    const [description, setdescription] = useState("");
    const [user, setuser] = useState([]);
    const [validation, setValidation] = useState(false);
    const navigate = useNavigate();
    const [imageFile, setImageFile] = useState(null);
    const [imageUrl, setImageUrl] = useState("");
    const [token,settoken] = useState(localStorage.getItem("token"))
    const [userId,setuserId] = useState(localStorage.getItem("userId"))

    const [selectedOption, setSelectedOption] = useState({ value: data.user.id, label: data.user.userName });
    const handleImageChange = (event) => {
        setImageFile(event.target.files[0]);
        setImageUrl(URL.createObjectURL(event.target.files[0]));
    };
    useEffect(() => {
        setId(data.id);
        setTitle(data.title);
        setdescription(data.description);
       
        setnewsDate(data.newsDate);

    }, [data, data.title,data.description,data.newsDate]);
    const handleSubmit = (e) => {
        e.preventDefault();
        const formData = new FormData();

        formData.append('id', id)
        formData.append('imageFile', imageFile);
        formData.append('title', title)
        formData.append('description', description)
        formData.append('userId', userId)
        formData.append('user.Id', userId)
        formData.append('newsDate',data.newsDate)
        fetch("https://localhost:7245/Admin/v1/api/news/"+ id, {
            method: "PUT",
            body: formData,
             headers: { 'Authorization': `Bearer ${token}`}
        }).then((res) => {
            alert('Bạn sửa tin tức')
            navigate('/MrSoai/news');
        }).catch((err) => {
            console.log(err.message)
        })

    }
    useEffect(() => {
        axios.get("https://localhost:7245/Admin/v1/api/user",{ headers: { 'Authorization': `Bearer ${token}`}})
            .then(response => {
                const userOption = response.data.map(item => ({
                    value: item.id,
                    label: item.userName
                }));
                axios.get(`https://localhost:7245/Admin/v1/api/news/${id}`,{ headers: { 'Authorization': `Bearer ${token}`}})
                .then(response => {
                    const newsdata = response.data;
                    const user = {
                        value: newsdata.useId,
                        label: newsdata.userName
                    };
                    userOption.push(user);
                    setuser(userOption);
                })
                .catch(error => {
                    console.error(error);
                });

            })
            .catch(error => {
                console.error(error);
            });
    }, [id]);
    const handleSelectChange = selectedOption => {
        setSelectedOption(selectedOption);
        console.log(data.newsDate)
    };

    return (
        <div>
            <Typography
                variant="h2"
                fontWeight="bold"
                sx={{ m: " 0 10px 5px 20px" }}
            >
                Sửa tin tức
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
                                    <label fontWeight="bold">Ghi chú</label>
                                    <input required value={description} onMouseDown={e => setValidation(true)} onChange={e => setdescription(e.target.value)} className="form-control"></input>
                                </div>
                            </div>


                            <div className="col-lg-12">
                            {imageUrl ? (
                                    <img src={imageUrl} alt="Selected file" width="60px" height="60px" />
                                ) : (
                                    <img src={`https://localhost:7245/newimages/${data.image}`} width="60px" height="60px" />
                                )}
                                <div className="form-group">
                                    <label htmlFor="imageFile">Chọn hình ảnh:</label>
                                    <input type="file" id="imageFile" onChange={handleImageChange} />
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