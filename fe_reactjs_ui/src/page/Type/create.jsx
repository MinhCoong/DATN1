import { useState } from "react";
import { Link, useNavigate } from "react-router-dom";
import { Typography, useTheme } from '@mui/material'
import { tokens } from '../../theme';
export default function CreateT() {
    const theme = useTheme();
    const colors = tokens(theme.palette.mode);
    const [id] = useState(0);
    const [catagoryName, namechange] = useState("");
    const [validation, valchange] = useState(false);
    const navigate = useNavigate();
    const [token,settoken] = useState(localStorage.getItem("token"))
    const handlesubmit = (e) => {
        e.preventDefault();
        const formdata = new FormData();
        formdata.append('id',id)
        formdata.append('categoryName',catagoryName) 
        fetch("https://localhost:7245/Admin/v1/api/category", {
            method: "POST",
            body: formdata,
            headers: { 'Authorization': `Bearer ${token}`}
        }).then((res) => {
            alert('Bạn muốn thêm loại sản phẩm')
            navigate('/MrSoai/type');
        }).catch((err) => {
            console.log(err.message)()
        })
    }

    return (
        <div>
            {/* //     <div className="row">*/}
            {/* <div className="offset-lg-3 col-lg-6">  */}
            <Typography
                variant="h2"
                color={colors.grey[100]}
                fontWeight="bold"
                sx={{ m: " 0 10px 5px 20px" }}
            >
                Thêm loại sản phẩm
            </Typography>
            <form onSubmit={handlesubmit}>
                <div style={{ "textAlign": "left" }}>

                    <div className="card-body">
                        <div className="row">
                           
                            <div className="col-lg-12">
                                <div className="form-group">
                                    <label fontWeight="bold">Tên loại</label>
                                    <input required value={catagoryName} onMouseDown={e => valchange(true)} onChange={e => namechange(e.target.value)} className="form-control"></input>
                                    {catagoryName.length == 0 && validation && <span className="text-danger">Enter the name</span>}
                                </div>
                            </div>
                           
                            <div className="col-lg-12 d-flex flex-row mt-4">
                                <div className="form-group">
                                    <button className="btn btn-success" type="submit">Lưu</button>
                                    
                                </div>
                                <div className="mx-3">
                                <Link to="/MrSoai/type" className="btn btn-danger">Thoát</Link>
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
