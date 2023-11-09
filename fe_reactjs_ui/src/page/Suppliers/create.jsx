import { useState } from "react";
import { Link, useNavigate } from "react-router-dom";
import { Typography, useTheme } from '@mui/material'
import { tokens } from '../../theme';

export default function CreateSuppliers() {
  const theme = useTheme();
  const colors = tokens(theme.palette.mode);
  const [ supplierName, setsupplierName] = useState("");
  const [supplierAddress, setsupplierAddress] = useState("");
  const [supplierPhoneNumber,setsupplierPhoneNumber] = useState("");
  const [supplierEmail,setsupplierEmail]=useState("");
  const [validation, valchange] = useState(false);
  const [token,settoken] = useState(localStorage.getItem("token"))
  const navigate = useNavigate();
  const handlesubmit = (e) => {
      e.preventDefault();
      const empdata = { supplierName,supplierAddress, supplierPhoneNumber, supplierEmail};
      fetch("https://localhost:7245/Admin/v1/api/Suppliers", {
          method: "POST",
          headers: { "content-type": "application/json",'Authorization': `Bearer ${token}` },
          body: JSON.stringify(empdata)
      }).then((res) => {
          alert('Bạn muốn thêm nhà cung cấp')
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
              Thêm nhà cung cấp
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