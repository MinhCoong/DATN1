import { useEffect, useState } from "react";
import { Link, useLocation, useNavigate } from "react-router-dom";
import { Typography } from '@mui/material'
import axios from "axios";
export default function CreateT() {
    const [id, setId] = useState("");
    const [productId, namechange] = useState([]);
    const [sizeId, setsize] = useState("");
    const [priceOfProduct, setprice] = useState("");
    const navigate = useNavigate();
    const location = useLocation();
    const data = location.state.data;
    const [token,settoken] = useState(localStorage.getItem("token"))
    useEffect(() => {
        setId(data.id);
        setprice(data.priceOfProduct)
    }, [data, data.priceOfProduct]);
    const handlesubmit = (e) => {
        e.preventDefault();
        const empdata = {
            "id":data.id,
            "productId": data.productId,
            "sizeId": data.sizeId,
            "priceOfProduct": priceOfProduct
          }
        fetch("https://localhost:7245/Admin/v1/api/prices/"+ empdata.id, {
            method: "PUT",
            headers: { "content-type": "application/json",'Authorization': `Bearer ${token}` },
            body: JSON.stringify(empdata)
        }).then((res) => {
            alert('Bạn muốn thêm sản phẩm'+data.productId)
            navigate('/MrSoai/price');
        }).catch((err) => {
            console.log(err.message)
        })
    }
    useEffect(() => {
        axios.get("https://localhost:7245/Admin/v1/api/product",{ headers: { 'Authorization': `Bearer ${token}`}})
            .then(response => {
                const productOptions = response.data.map(item => ({
                    value: item.id,
                    label: item.productName
                }));
                axios.get(`https://localhost:7245/Admin/v1/api/prices/${id}`,{ headers: { 'Authorization': `Bearer ${token}`}})
                .then(response => {
                    const prices = response.data;
                    const product = {
                        value: prices.productId,
                    };
                    productOptions.push(product);
                    namechange(productOptions);
                })
                .catch(error => {
                    console.error(error);
                });
                namechange(productId);
            })
            .catch(error => {
                console.error(error);
            });
    }, [id]);
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
    return (
        <div>
            <Typography
                variant="h2"
                fontWeight="bold"
                sx={{ m: " 0 10px 5px 20px" }}
            >
                Sửa giá tiền 
            </Typography>
            <form onSubmit={handlesubmit}>
                <div style={{ "textAlign": "left" }}>

                    <div className="card-body">
                        <div className="row">
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
