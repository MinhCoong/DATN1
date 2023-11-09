import { useState } from "react";
import { Link, useNavigate } from "react-router-dom";
import { Typography, useTheme } from '@mui/material'
import { tokens } from '../../theme';
export default function CreateT() {
    const theme = useTheme();
    const colors = tokens(theme.palette.mode);
    const [token,settoken] = useState(localStorage.getItem("token"))
    const [sizeName, setsizeName] = useState("");
    const [validation, valchange] = useState(false);
    const navigate = useNavigate();
    const handlesubmit = (e) => {
        e.preventDefault();
        const empdata = { sizeName };
        fetch("https://localhost:7245/Admin/v1/api/Sizes", {
            method: "POST",
            headers: { "content-type": "application/json",'Authorization': `Bearer ${token}` },
            body: JSON.stringify(empdata)
        }).then((res) => {
            alert('Bạn muốn thêm loại sản phẩm')
            navigate('/MrSoai/size');
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
                Thêm size
            </Typography>
            <form onSubmit={handlesubmit}>
                <div style={{ "textAlign": "left" }}>
                    <div className="card-body">
                        <div className="row">
                            <div className="col-lg-12">
                                <div className="form-group">
                                    <label fontWeight="bold">Tên loại</label>
                                    <input required value={sizeName} onMouseDown={e => valchange(true)} onChange={e => setsizeName(e.target.value)} className="form-control"></input>
                                    {sizeName.length == 0 && validation && <span className="text-danger">Enter the name</span>}
                                </div>
                            </div>
                           
                            <div className="col-lg-12 d-flex flex-row mt-4">
                                <div className="form-group">
                                    <button className="btn btn-success" type="submit">Lưu</button>
                                    
                                </div>
                                <div className="mx-3">
                                <Link to="/MrSoai/size" className="btn btn-danger">Thoát</Link>
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
