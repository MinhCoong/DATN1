import React from 'react'
import { Typography, useTheme } from "@mui/material";
import { useEffect, useState } from "react";
import { Link, useNavigate } from "react-router-dom";
import { tokens } from "../../theme";

export default function CreateIn() {
    const theme = useTheme();
    const colors = tokens(theme.palette.mode);
    const [ ingredientName, setingredientName] = useState("");
    const [unit, setunit] = useState("");
    const [quantity,setquantity] = useState("");
    const [validation, valchange] = useState(false);
    const navigate = useNavigate();
    
    const handlesubmit = (e) => {
        e.preventDefault();
        const empdata = { ingredientName,unit, quantity};
        fetch("https://localhost:7245/Admin/v1/api/Ingredients/", {
            method: "POST",
            headers: { "content-type": "application/json" },
            body: JSON.stringify(empdata)
        }).then((res) => {
            alert('Thêm thành công')
            navigate('/MrSoai/ware');
        }).catch((err) => {
            console.log(err.message)
        })
    }
  
    return (
        <div>
            <Typography
                variant="h2"
                color={colors.grey[100]}
                fontWeight="bold"
                sx={{ m: " 0 10px 5px 20px" }}
            >
                Thêm nguyên liệu
            </Typography>
            <form onSubmit={handlesubmit}>
                <div style={{ "textAlign": "left" }}>
                    <div className="card-body">
                        <div className="row">
                            <div className="col-lg-12">
                                <div className="form-group">
                                    <label fontWeight="bold">Tên nguyên liệu</label>
                                    <input required value={ingredientName} onMouseDown={e => valchange(true)} onChange={e => setingredientName(e.target.value)} className="form-control"></input>
                                    {ingredientName.length === 0 && validation && <span className="text-danger">Enter the name</span>}
                                </div>
                            </div>
                            <div className="col-lg-12">
                                <div className="form-group">
                                    <label fontWeight="bold">Đơn vị</label>
                                    <input required value={unit} onMouseDown={e => valchange(true)} onChange={e => setunit(e.target.value)} className="form-control"></input>
                                </div>
                            </div>
                            <div className="col-lg-12">
                                <div className="form-group">
                                    <label fontWeight="bold">SL</label>
                                    <input required type="number" value={quantity} onMouseDown={e => valchange(true)} onChange={e => setquantity(e.target.value)} className="form-control"></input>
                                </div>
                            </div>
                           
                            <div className="col-lg-12 d-flex flex-row mt-4">
                                <div className="form-group">
                                    <button className="btn btn-success" type="submit">Lưu</button>
                                    
                                </div>
                                <div className="mx-3">
                                <Link to="/MrSoai/ware" className="btn btn-danger">Thoát</Link>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </form>
            {/* //         </div>*/}
            {/* </div>  */}
        </div>
    );
}
