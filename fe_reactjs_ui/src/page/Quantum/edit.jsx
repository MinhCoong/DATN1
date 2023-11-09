import { Typography, useTheme } from "@mui/material";
import { useEffect, useState } from "react";
import { Link, useNavigate, useLocation } from "react-router-dom";

import { tokens } from "../../theme";

export default function EditQ() {
    const theme = useTheme();
    const colors = tokens(theme.palette.mode);
    const [id, setId] = useState("");
    const [quantum, setquantums] = useState("");
    const [validation, valchange] = useState(false);
    const navigate = useNavigate();
    const [token,settoken] = useState(localStorage.getItem("token"))
    const location = useLocation();
    const data = location.state.data;
    useEffect(() => {
        setId(data.id);
        setquantums(data.quantity);
      }, [data, data.quantity]);

    const handlesubmit = async (e) =>  {
        e.preventDefault();
        const empdata = { 
            'id': id,
            'quantity': quantum
         };
      await  fetch("https://localhost:7245/api/Quantums/" + empdata.id, {
            method: "PUT",
            headers: { "content-type": "application/json"},
            body: JSON.stringify(empdata)
        }).then((res) => {
            alert("Sửa theo mong muốn")

            navigate('/MrSoai/quantums');
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
                Sửa định lượng

            </Typography>
            <form className="container" onSubmit={handlesubmit}>

                <div style={{ "textAlign": "left" }}>
                    <div className="card-body">

                        <div className="row">
                            <div className="col-lg-12">
                                <div className="form-group">
                                    <label>Định lượng</label>
                                    <input required value={quantum} onMouseDown={e => valchange(true)} onChange={e => setquantums(e.target.value)} className="form-control"></input>
                                    {/* {catagoryName.length == 0 && validation && <span className="text-danger">Enter the name</span>} */}
                                </div>
                            </div>
                            
                            <div className="col-lg-12">
                                <div className="form-group">
                                    <button className="btn btn-success" type="submit">Lưu</button>
                                    <Link to="/MrSoai/quantums" className="btn btn-danger">Thoát</Link>
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
