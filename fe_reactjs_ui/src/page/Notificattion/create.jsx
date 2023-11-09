import { useState } from "react";
import { Link, useNavigate } from "react-router-dom";
import { Typography } from '@mui/material'
export default function CreateNotifi() {
  const [title, setTitle] = useState("");
  const [body, setbody] = useState("");
  const [validation, setValidation] = useState(false);
  const navigate = useNavigate();
  const [token,settoken] = useState(localStorage.getItem("token"))
  const handleSubmit = (e) => {
    e.preventDefault();
    const formData = new FormData();
    formData.append('title', title)
    formData.append('body', body);
    fetch("https://localhost:7245/Admin/v1/api/Notifications/send-notification-to-all-user?body=" + body, {
      method: "POST",
      body: formData,
      headers: { 'Authorization': `Bearer ${token}`}
    }).then((res) => {
      alert('Bạn muốn thêm thông báo')
      navigate('/MrSoai/notification');
    }).catch((err) => {
      console.log(err.message)
    })
    console.log(title)
  }

  return (
    <div>
      <Typography
        variant="h2"
        fontWeight="bold"
        sx={{ m: " 0 10px 5px 20px" }}
      >
        Thêm Thông báo
      </Typography>
      <form onSubmit={handleSubmit}>
        <div style={{ "textAlign": "left" }}>

          <div className="card-body">
            <div className="row">
              
              <div className="col-lg-12">
                <div className="form-group">
                  <label fontWeight="bold">Tiêu đề</label>
                  <input required value={title} onChange={e => setTitle(e.target.value)} className="form-control"></input>
                  {title.length === 0 && validation && <span className="text-danger">Enter the name</span>}
                </div>
              </div>
              <div className="col-lg-12">
                <div className="form-group">
                  <label fontWeight="bold">Nội dung</label>
                  <input required value={body} onMouseDown={e => setValidation(true)} onChange={e => setbody(e.target.value)} className="form-control"></input>
                </div>
              </div>
              <div className="col-lg-12 d-flex flex-row mt-4">
                <div className="form-group">
                  <button className="btn btn-success" type="submit">Lưu</button>
                </div>
                <div className="mx-3">
                  <Link to="/MrSoai/notification" className="btn btn-danger">Thoát</Link>
                </div>
              </div>
            </div>
          </div>
        </div>
      </form>
    </div>
  );
}
