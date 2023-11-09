import { Typography, useTheme } from "@mui/material";
import { useEffect, useState } from "react";
import { Link, useNavigate, useLocation } from "react-router-dom";

import { tokens } from "../../theme";

export default function EditT() {
    const theme = useTheme();
    const colors = tokens(theme.palette.mode);
    const [id, setId] = useState("");
    const [categoryName, setCatagoryName] = useState("");
    const [validation, valchange] = useState(false);
    const navigate = useNavigate();
    const [token,settoken] = useState(localStorage.getItem("token"))
    const location = useLocation();
    const data = location.state.data;
    const initialCatagoryName = data.categoryName;
    useEffect(() => {
        setId(data.id);
        setCatagoryName(initialCatagoryName);
      }, [data, initialCatagoryName]);

    const handlesubmit = async (e) =>  {
        e.preventDefault();
        const empdata = { id, categoryName };
      await  fetch("https://localhost:7245/Admin/v1/api/category/" + empdata.id, {
            method: "PUT",
            headers: {
                "content-type": "application/json",
                'Authorization': `Bearer ${token}`
              },
            body: JSON.stringify(empdata)
        }).then((res) => {
            // alert('Saved successfully.')
            alert("Sửa theo mong muốn")

            navigate('/MrSoai/type');
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
                Sửa loại sản phẩm

            </Typography>
            <form className="container" onSubmit={handlesubmit}>

                <div style={{ "textAlign": "left" }}>
                    <div className="card-body">

                        <div className="row">

                            <div className="col-lg-12">
                                <div className="form-group">
                                    <label>ID</label>
                                    <input value={data.id} disabled="disabled" className="form-control"></input>
                                </div>
                            </div>

                            <div className="col-lg-12">
                                <div className="form-group">
                                    <label>Tên loại</label>
                                    <input required value={categoryName} onMouseDown={e => valchange(true)} onChange={e => setCatagoryName(e.target.value)} className="form-control"></input>
                                    {/* {catagoryName.length == 0 && validation && <span className="text-danger">Enter the name</span>} */}
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

        </div>
        //     </div>
        // </div>
    );
}
