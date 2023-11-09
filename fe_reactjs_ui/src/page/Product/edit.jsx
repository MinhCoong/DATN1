import { useEffect, useState } from "react";
import { Link, useLocation, useNavigate } from "react-router-dom";
import { Typography, colors } from '@mui/material'
import Select from 'react-select';
import axios from "axios";
import './create.css';
export default function CreateT() {
    const location = useLocation();
    const data = location.state.data;
    const [id, setId] = useState("");
    const [productName, namechange] = useState("");
    const [description, descriptionchange] = useState("");
    const [category, categorychange] = useState([]);
    const [selectedOption, setSelectedOption] = useState({ value: data.category.id, label: data.category.categoryName });
    const [validation, valchange] = useState(false);
    const navigate = useNavigate();
    const initialProductName = data.productName;
    const [imageFile, setImageFile] = useState(null);
    const [imageUrl, setImageUrl] = useState("");
    const [selectcategory, setcate] = useState("")
    const [token,settoken] = useState(localStorage.getItem("token"))
    const handleImageChange = (event) => {
        setImageFile(event.target.files[0]);
        setImageUrl(URL.createObjectURL(event.target.files[0]));
    };
    useEffect(() => {
        setId(data.id);
        namechange(initialProductName);
        descriptionchange(data.description);
        categorychange([]);
    }, [data, initialProductName]);
    // const empdata = { id, productName, description, category };
    const handleSubmit = (e) => {
        e.preventDefault();
        const formData = new FormData();

        formData.append('id', id)
        formData.append('imageFile', imageFile);
        formData.append('productName', productName)
        formData.append('description', description)
        formData.append('categoryId', selectedOption.value)
        formData.append('category.Id', selectedOption.value)

        fetch("https://localhost:7245/Admin/v1/api/product/" + id, {
            method: "PUT",
            body: formData,
            headers: { 'Authorization': `Bearer ${token}`}
        }).then((res) => {
            alert('Bạn muốn sửa sản phẩm')
            navigate('/MrSoai/product');
        }).catch((err) => {
            console.log(err.message)
        })

    }
    useEffect(() => {
        axios.get("https://localhost:7245/Admin/v1/api/category",{ headers: { 'Authorization': `Bearer ${token}`}})
            .then(response => {
                const categoryOptions = response.data.map(item => ({
                    value: item.id,
                    label: item.categoryName
                }));
                axios.get(`https://localhost:7245/v1/api/product/${id}`,{ headers: { 'Authorization': `Bearer ${token}`}})
                    .then(response => {
                        const productData = response.data;
                        const category = {
                            value: productData.categoryId,
                            label: productData.categoryName
                        };
                        categoryOptions.push(category);
                        categorychange(categoryOptions);
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
        setcate(selectedOption.value);
    }

    return (
        <div>
            <Typography
                variant="h2"
                fontWeight="bold"
                sx={{ m: " 0 10px 5px 20px" }}
            >
                Sửa sản phẩm
            </Typography>
            <form onSubmit={handleSubmit}>
                <div style={{ "textAlign": "left" }}>

                    <div className="card-body">
                        <div className="row">
                            <div className="col-lg-12">
                                <div className="form-group">
                                    <label fontWeight="bold">ID</label>
                                    <input value={id} disabled="disabled" className="form-control"></input>
                                </div>
                            </div>

                            <div className="col-lg-12">
                                <div className="form-group">
                                    <label fontWeight="bold">Tên sản phẩm</label>
                                    <input required value={productName} onMouseDown={e => valchange(true)} onChange={e => namechange(e.target.value)} className="form-control"></input>
                                    {productName.length == 0 && validation && <span className="text-danger">Enter the name</span>}
                                </div>
                            </div>

                            <div className="col-lg-12">
                                <div className="form-group">
                                    <label fontWeight="bold">Ghi chú</label>
                                    <input required value={description} onMouseDown={e => valchange(true)} onChange={e => descriptionchange(e.target.value)} className="form-control"></input>
                                </div>
                            </div>

                            <div className="col-lg-12">
                                <div className="form-group">
                                    <label fontWeight="bold">Loại sản phẩm</label>
                                    <Select
                                        defaultValue={{ label: data.category.categoryName }}
                                        options={category}
                                        value={selectedOption}
                                        onChange={handleSelectChange}
                                        className="text"
                                    />
                                </div>
                            </div>
                            <div className="col-lg-12">
                                {imageUrl ? (
                                    <img src={imageUrl} alt="Selected file" width="60px" height="60px" />
                                ) : (
                                    <img src={`https://localhost:7245/uploadimages/${data.image}`} width="60px" height="60px" />
                                )}
                                <div className="form-group">
                                    <label htmlFor="imageFile">Chọn hình ảnh: </label>
                                    <input type="file" id="imageFile" className="px-3" onChange={handleImageChange} />
                                </div>
                            </div>

                            <div className="col-lg-12 d-flex flex-row mt-4">
                                <div className="form-group">
                                    <button className="btn btn-success" type="submit">Lưu</button>

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
