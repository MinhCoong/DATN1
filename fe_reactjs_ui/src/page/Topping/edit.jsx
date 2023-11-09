import { useEffect, useState } from "react";
import { Link, useLocation, useNavigate } from "react-router-dom";
import { Typography } from '@mui/material'


export default function CreateT() {
    const location = useLocation();
    const data = location.state.data;
    const [id, setId] = useState(0);
    const [toppingName, setName] = useState("");
    const [price, setPrice] = useState("");
    const [validation, setValidation] = useState(false);
    const navigate = useNavigate();
    const [imageFile, setImageFile] = useState(null);
    const [imageUrl, setImageUrl] = useState("");
    const handleImageChange = (event) => {
        setImageFile(event.target.files[0]);
        setImageUrl(URL.createObjectURL(event.target.files[0]));
    };
    const [token,settoken] = useState(localStorage.getItem("token"))
    useEffect(() => {
        setId(data.id);
        setName(data.toppingName);
        setPrice(data.price);
    }, [data, data.toppingName]);

    const handleSubmit = (e) => {
        e.preventDefault();
        const formData = new FormData();

        formData.append('id', id)
        formData.append('imageFile', imageFile);
        formData.append('toppingName', toppingName)
        formData.append('price', price)

        
        fetch("https://localhost:7245/Admin/v1/api/topping/" + id, {
            method: "PUT",
            body: formData,
            headers: { 'Authorization': `Bearer ${token}`}
        }).then((res) => {
            alert('Bạn muốn sửa topping')
            navigate('/MrSoai/topping');
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
                Sửa topping
            </Typography>
            <form onSubmit={handleSubmit}>
                <div style={{ "textAlign": "left" }}>

                    <div className="card-body">
                        <div className="row">


                            <div className="col-lg-12">
                                <div className="form-group">
                                    <label fontWeight="bold">Tên topping</label>
                                    <input required value={toppingName} onMouseDown={e => setValidation(true)} onChange={e => setName(e.target.value)} className="form-control"></input>
                                    {toppingName.length === 0 && validation && <span className="text-danger">Enter the name</span>}
                                </div>
                            </div>

                            <div className="col-lg-12">
                                <div className="form-group">
                                    <label fontWeight="bold">Giá tiền</label>
                                    <input required value={price} onMouseDown={e => setValidation(true)} onChange={e => setPrice(e.target.value)} className="form-control"></input>
                                </div>
                            </div>
                            <div className="col-lg-12">
                                {imageUrl ? (
                                    <img src={imageUrl} alt="Selected file" width="60px" height="60px" />
                                ) : (
                                    <img src={`https://localhost:7245/uploadimages/${data.image}`} width="60px" height="60px" />
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
                                <Link to="/MrSoai/topping" className="btn btn-danger">Thoát</Link>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </form>
        </div>
    );
}