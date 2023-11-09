import { useEffect, useState } from "react";
import { Link, useNavigate } from "react-router-dom";
import { Typography } from '@mui/material'
import Select from 'react-select';
import axios from "axios";
import './create.css';

export default function CreateT() {
    const [id] = useState(0);
    const [productName, setName] = useState("");
    const [description, setDescription] = useState("");
    const [category, setCategory] = useState("");
    const [selectedOption, setSelectedOption] = useState(null);
    const [validation, setValidation] = useState(false);
    const navigate = useNavigate();
    const [imageFile, setImageFile] = useState(null);
    const [imageUrl, setImageUrl] = useState("");
    const [token,settoken] = useState(localStorage.getItem("token"))
    const handleImageChange = (event) => {
        setImageFile(event.target.files[0]);
        setImageUrl(URL.createObjectURL(event.target.files[0]));
    };
   
    const handleSubmit = (e) => {
        e.preventDefault();
        const formData = new FormData();

        formData.append('id', id)
        formData.append('imageFile', imageFile);
        formData.append('productName', productName)
        formData.append('description', description)
        formData.append('categoryId', selectedOption.value)
        formData.append('category.Id', selectedOption.value)

        fetch("https://localhost:7245/Admin/v1/api/product", {
            method: "POST",
            body: formData,
            headers: { 'Authorization': `Bearer ${token}`}
        }).then((res) => {
            alert('Bạn muốn thêm sản phẩm')
            navigate('/MrSoai/product');
        }).catch((err) => {
            console.log(err.message)
        })

    }
    useEffect(() => {
        axios.get("https://localhost:7245/Admin/v1/api/category",{ headers: { 'Authorization': `Bearer ${token}`}})
            .then(response => {
                const category = response.data.map(item => ({
                    value: item.id,
                    label: item.categoryName
                }));
                setCategory(category);
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
                Thêm sản phẩm
            </Typography>
            <form onSubmit={handleSubmit}>
                <div style={{ "textAlign": "left" }}>

                    <div className="card-body">
                        <div className="row">
                            

                            <div className="col-lg-12">
                                <div className="form-group">
                                    <label fontWeight="bold">Tên sản phẩm</label>
                                    <input required value={productName} onMouseDown={e => setValidation(true)} onChange={e => setName(e.target.value)} className="form-control"></input>
                                    {productName.length === 0 && validation && <span className="text-danger">Enter the name</span>}
                                </div>
                            </div>

                            <div className="col-lg-12">
                                <div className="form-group">
                                    <label fontWeight="bold">Ghi chú</label>
                                    <input required value={description} onMouseDown={e => setValidation(true)} onChange={e => setDescription(e.target.value)} className="form-control"></input>
                                </div>
                            </div>

                            <div className="col-lg-12">
                                <div className="form-group">
                                    <label fontWeight="bold">Loại sản phẩm</label>
                                    <Select
                                    required
                                        options={category}
                                        value={selectedOption}
                                        onChange={handleSelectChange}
                                        className="text"
                                    />
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
                                    <button className="btn btn-success" type="submit">lưu</button>
                                    
                                </div>
                                <div className="mx-3">
                                <Link to="/MrSoai/product" className="btn btn-danger">Thoát</Link>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </form>
        </div>
    );
}