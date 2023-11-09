import { Typography, useTheme } from "@mui/material";
import { useEffect, useState } from "react";
import { Link, useNavigate, useLocation } from "react-router-dom";
import Select from 'react-select';
import { tokens } from "../../theme";
import axios from "axios";

export default function EditCT() {
    const theme = useTheme();
    const colors = tokens(theme.palette.mode);
    const [id, setId] = useState("");
    const [category, setcategory] = useState([])
    const navigate = useNavigate();
    const [token, settoken] = useState(localStorage.getItem("token"))
    const location = useLocation();
    const data = location.state.data;
    const [selectedOption, setSelectedOption] = useState({ value: data.category.id, label: data.category.categoryName });
    const [topping, settoppings] = useState({ value: data.toppings.id, label: data.toppings.toppingName });
    useEffect(() => {
        setId(data.id);
        setcategory([])
        settoppings(data.toppings.id);
    }, [data.id,data.toppings.id]);
    useEffect(() => {
        axios.get("https://localhost:7245/Admin/v1/api/category",{ headers: { 'Authorization': `Bearer ${token}`}})
            .then(response => {
                const categoryOptions = response.data.map(item => ({
                    value: item.id,
                    label: item.categoryName
                }));
                setcategory(categoryOptions)
            })
            .catch(error => {
                console.error(error);
            });
    }, [id]);
    const handlesubmit = async (e) => {
        e.preventDefault();
            const empdata = { 
                'id': id,
                "toppingsId": topping,
                "categoryId": selectedOption.value,
             };
          await  fetch("https://localhost:7245/api/CategoryAndToppings/" + empdata.id, {
                method: "PUT",
                headers: { "content-type": "application/json",'Authorization': `Bearer ${token}`},
                body: JSON.stringify(empdata)
            }).then((res) => {
                alert("Sửa thành công")
                navigate('/MrSoai/categorytopping');
            }).catch((err) => {
                console.log(err.message)
            })      
    }
    const handleSelectChange = selectedOption => {
        setSelectedOption(selectedOption);
    }
    return (
        <div>
            <Typography
                variant="h2"
                color={colors.grey[100]}
                fontWeight="bold"
                sx={{ m: " 0 10px 5px 20px" }}
            >
                Sửa định lượng

            </Typography>
            <form className="container" onSubmit={handlesubmit}>
                <div style={{ "textAlign": "left" }}>
                    <div className="card-body">
                        <div className="row">
                            <div className="col-lg-12">
                                <div className="form-group">
                                    <label fontWeight="bold">Tên topping</label>
                                    <input value={topping.label} disabled="disabled" className="form-control"></input>
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
                            <div className="col-lg-12 mt-2">
                                <div className="form-group">
                                    <button className="btn btn-success m-2" type="submit">Lưu</button>
                                    <Link to="/MrSoai/categorytopping" className="btn btn-danger">Thoát</Link>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </form>
        </div>
    );
}
