import { Typography, useTheme } from "@mui/material";
import { useEffect, useState } from "react";
import { Link, useNavigate, useLocation } from "react-router-dom";
import { tokens } from "../../theme";

export default function EditSuppliers() {
  const theme = useTheme();
  const colors = tokens(theme.palette.mode);
  const [id, idchange] = useState("");
  const [ supplierName, setsupplierName] = useState("");
  const [supplierAddress, setsupplierAddress] = useState("");
  const [supplierPhoneNumber,setsupplierPhoneNumber] = useState("");
  const [supplierEmail,setsupplierEmail]=useState("");
  const [validation, valchange] = useState(false);
  const location = useLocation();
  const [token,settoken] = useState(localStorage.getItem("token"))
  const data = location.state.data;
  const navigate = useNavigate();
  useEffect(() => {
    idchange(data.id);
    setsupplierName(data.supplierName);
    setsupplierAddress(data.supplierAddress);
    setsupplierPhoneNumber(data.supplierPhoneNumber);
    setsupplierEmail(data.supplierEmail);
  }, [data, data.supplierName,data.supplierAddress,data.supplierPhoneNumber,data.supplierEmail]);
  const handlesubmit = (e) => {
      e.preventDefault();
      const empdata = { id,supplierName,supplierAddress, supplierPhoneNumber, supplierEmail};
      fetch("https://localhost:7245/Admin/v1/api/Suppliers/"+ empdata.id, {
          method: "PUT",
          headers: { "content-type": "application/json",'Authorization': `Bearer ${token}` },
          body: JSON.stringify(empdata)
      }).then((res) => {
          alert('Bạn muốn sửa nhà cung cấp')
          navigate('/MrSoai/suppliers');
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
              Sửa nhà cung cấp
          </Typography>
          <form onSubmit={handlesubmit}>
              <div style={{ "textAlign": "left" }}>
                  <div className="card-body">
                      <div className="row">
                          <div className="col-lg-12">
                              <div className="form-group">
                                  <label fontWeight="bold">Tên nhà cung cấp</label>
                                  <input required value={supplierName} onMouseDown={e => valchange(true)} onChange={e => setsupplierName(e.target.value)} className="form-control"></input>
                                  {supplierName.length === 0 && validation && <span className="text-danger">Enter the name</span>}
                              </div>
                          </div>
                          <div className="col-lg-12">
                              <div className="form-group">
                                  <label fontWeight="bold">Địa chỉ</label>
                                  <input required value={supplierAddress} onMouseDown={e => valchange(true)} onChange={e => setsupplierAddress(e.target.value)} className="form-control"></input>
                              </div>
                          </div>
                          <div className="col-lg-12">
                              <div className="form-group">
                                  <label fontWeight="bold">SDT</label>
                                  <input required type="number" value={supplierPhoneNumber} onMouseDown={e => valchange(true)} onChange={e => setsupplierPhoneNumber(e.target.value)} className="form-control"></input>
                              </div>
                          </div>
                          <div className="col-lg-12">
                              <div className="form-group">
                                  <label fontWeight="bold">Email</label>
                                  <input required type="email" value={supplierEmail} onMouseDown={e => valchange(true)} onChange={e => setsupplierEmail(e.target.value)} className="form-control"></input>
                              </div>
                          </div>
                          <div className="col-lg-12 d-flex flex-row mt-4">
                              <div className="form-group">
                                  <button className="btn btn-success" type="submit">Lưu</button>
                                  
                              </div>
                              <div className="mx-3">
                              <Link to="/MrSoai/suppliers" className="btn btn-danger">Thoát</Link>
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