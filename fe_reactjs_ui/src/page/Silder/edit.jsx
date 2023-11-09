import { useEffect, useState } from "react";
import { Link, useNavigate, useLocation } from "react-router-dom";
import { Typography } from '@mui/material'

export default function EditSlider() {
    const location = useLocation();
    const data = location.state.data;
    const [id, setId] = useState(0);
    const [dateAdd, setDate] = useState("");
    const navigate = useNavigate();
    const [imageFile, setImageFile] = useState(null);
    const [imageUrl, setImageUrl] = useState("");
    const [token,settoken] = useState(localStorage.getItem("token"))
    const handleImageChange = (event) => {
        setImageFile(event.target.files[0]);
        setImageUrl(URL.createObjectURL(event.target.files[0]));
    };
    useEffect(() => {
        setId(data.id)
        setDate(data.dateAdd)
    }, [data.id, data.dateAdd]);
    const handleSubmit = (e) => {
        e.preventDefault();
        const formData = new FormData();

        formData.append('id', id)
        formData.append('imageFile', imageFile);
        formData.append('dateAdd', data.dateAdd)


        fetch("https://localhost:7245/Admin/v1/api/Sliders", {
            method: "PUT",
            body: formData,
            headers: { 'Authorization': `Bearer ${token}`}
        }).then((res) => {
            alert('Bạn muốn sửa Slider')
            navigate('/MrSoai/slider');
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
                Sửa Slider
            </Typography>
            <form onSubmit={handleSubmit}>
                <div style={{ "textAlign": "left" }}>
                    <div className="card-body">
                        <div className="row">

                        <div className="col-lg-12">
                            {imageUrl ? (
                                    <img src={imageUrl} alt="Selected file" width="60px" height="60px" />
                                ) : (
                                    <img src={`https://localhost:7245/uploadImgSlider/${data.imageSlider}`} width="60px" height="60px" />
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
                                    <Link to="/MrSoai/slider" className="btn btn-danger">Thoát</Link>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </form>
        </div>
    );
}