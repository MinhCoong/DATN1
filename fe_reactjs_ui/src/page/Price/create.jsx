import { useEffect, useState } from "react";
import { Link, useNavigate } from "react-router-dom";
import { Typography } from '@mui/material'
import Select from 'react-select';
import axios from "axios";
export default function CreateT() {
    const [productId, namechange] = useState("");
    const [sizeId, setsize] = useState("");
    const [priceOfProduct, setprice] = useState("");
    const [selectedOption, setSelectedOption] = useState(null);
    const [validation, valchange] = useState(null);
    const navigate = useNavigate();
    const [token,settoken] = useState(localStorage.getItem("token"))
    const handlesubmit = (e) => {
        e.preventDefault();
        const empdata = {
            "productId": selectedOption.value,
            "sizeId": validation.value,
            "priceOfProduct": priceOfProduct
          }
        fetch("https://localhost:7245/Admin/v1/api/prices", {
            method: "POST",
            headers: { "content-type": "application/json",'Authorization': `Bearer ${token}` },
            body: JSON.stringify(empdata)
        }).then((res) => {
            alert('Bạn muốn thêm giá sản phẩm')
            navigate('/MrSoai/price');
        }).catch((err) => {
            console.log(err.message)
        })
    }
    useEffect(() => {
        axios.get("https://localhost:7245/Admin/v1/api/product",{ headers: { 'Authorization': `Bearer ${token}`}})
            .then(response => {
                const productId = response.data.map(item => ({
                    value: item.id,
                    label: item.productName
                }));
                namechange(productId);
            })
            .catch(error => {
                console.error(error);
            });
    }, []);
    useEffect(() => {
        axios.get("https://localhost:7245/Admin/v1/api/sizes",{ headers: { 'Authorization': `Bearer ${token}`}})
            .then(response => {
                const sizeId = response.data.map(item => ({
                    value: item.id,
                    label: item.sizeName
                }));
                setsize(sizeId);
            })
            .catch(error => {
                console.error(error);
            });
    }, []);
    const handleSelectChange = selectedOption => {
        setSelectedOption(selectedOption);
        
    };
    const handleSelect = selectedOption => {
        valchange(selectedOption);
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
            <form onSubmit={handlesubmit}>
                <div style={{ "textAlign": "left" }}>

                    <div className="card-body">
                        <div className="row">

                            <div className="col-lg-12">
                                <div className="form-group">
                                    <label fontWeight="bold">Sản phẩm</label>
                                    <Select
                                    required
                                        options={productId}
                                        value={selectedOption}
                                        onChange={handleSelectChange}
                                        className="text"
                                    />
                                </div>
                            </div>

                            <div className="col-lg-12">
                                <div className="form-group">
                                    <label fontWeight="bold">Chọn size</label>
                                    <Select
                                    required
                                        options={sizeId}
                                        value={validation}
                                        onChange={handleSelect}
                                        className="text"
                                    />
                                </div>
                            </div>

                            <div className="col-lg-12">
                                <div className="form-group">
                                    <label fontWeight="bold">Giá tiền</label>
                                    <input required value={priceOfProduct} onChange={e => setprice(e.target.value)} className="form-control"></input>
                                </div>
                            </div>
                            <div className="col-lg-12 d-flex flex-row mt-4">
                                <div className="form-group">
                                    <button className="btn btn-success" type="submit">Lưu</button>
                                    
                                </div>
                                <div className="mx-3">
                                <Link to="/MrSoai/price" className="btn btn-danger">Thoát</Link>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </form>
        </div>
    );
}
