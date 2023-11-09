import { Box, Button, Typography } from "@mui/material";
import { DataGrid } from "@mui/x-data-grid";
import { useEffect, useState } from "react";
import './create.css';
import { Link } from "react-router-dom";
import Select from 'react-select';
import axios from "axios";

export default function Inventory() {
    const [showRow, setShowRow] = useState(false);
    const [checkDatime, setSelectedDate] = useState('');
    const [selected, setSelected] = useState(null);
    const [description, setdescription] = useState("");
    const [userId,setuserId] = useState(localStorage.getItem("userId"))

    const [data, setData] = useState([]);
    const [ingredients, setIngredients] = useState("")
    const [ingredientList, setingredientList] = useState("")
    const [newIngredient, setNewIngredient] = useState({
        ingredientsId: "",
        quantity: "",
    }); 
    const [rows, setRows] = useState([]);
   
    const handleInputChange = (event) => {
        const { name, value } = event.target;
        setNewIngredient(prevState => ({
            ...prevState,
            [name]: value
        }));
    };
    const SelectDate = (event) => {
        setSelectedDate(event.target.value);
    };
    const SelectDes = (event) => {
        setdescription(event.target.value);
    };
    const handleadd = (event) => {
        event.preventDefault();
        const ingredient = ingredientList.find((item) => item.id === newIngredient.ingredientsId);
        const newRow = {
          ...newIngredient,
          id: new Date().getTime(),
          ingredientName: ingredient ? ingredient.ingredientName : "",
        };
        setRows([...rows, newRow]);
        setNewIngredient({
          ingredientsId: "",
          actualQuantity: "",
        //   discrepancyQuantity: "",
        });
      };
    const handleDelete = (id) => {
        setRows(rows.filter((row) => row.id !== id));
    };
    const handleSelect = (select) => {
        setSelected(select);
        const { value } = select;
        setNewIngredient({
            ...newIngredient,
            ingredientsId: value,
        });
    };
    const handlesubmit = (e) => {
        e.preventDefault();
        setShowRow(!showRow )
        const empdata = {
            "userId": userId,
            "description": description,
            "checkDatime": checkDatime,
            "status": true
        }
        fetch("https://localhost:7245/api/GoodsIssues", {
            method: "POST",
            headers: { "content-type": "application/json" },
            body: JSON.stringify(empdata)
        }).then((res) => {
            alert('Bạn muốn xuất kho')

        }).catch((err) => {
            console.log(err.message)
        })
    }
    const handleDataChange = (params) => {
        setData(params.row);
    };

    const handleSave = (e) => {
        e.preventDefault();
        const empdata = rows.map(item => ({
            "ingredientsId": item.ingredientsId,
            "quantity": item.actualQuantity,
            "status": true
        }));
        fetch("https://localhost:7245/api/GoodsIssueDetails", {
            method: "POST",
            headers: { "content-type": "application/json" },
            body: JSON.stringify(empdata)   
        }).then((res) => {
            alert('Dữ liệu đã được lưu thành công')

        }).catch((err) => {
            console.log(err.message)
        })
        console.log(empdata)
    }
    useEffect(() => {
        axios.get("https://localhost:7245/Admin/v1/api/Ingredients")
            .then(response => {
                const Ingredients = response.data.map(item => ({
                    value: item.id,
                    label: item.ingredientName
                }));
                const data = response.data
                setingredientList(data)
                setIngredients(Ingredients);
            })
            .catch(error => {
                console.error(error);
            });
    }, []);

    const columns: GridColDef[] = [
        
        {
            field: 'ingredientName',
            headerName: 'Tên nguyên liệu',
            width: 280,
            editable: true,

        },
        {
            field: 'actualQuantity',
            headerName: 'Số lượng',

            width: 150,
            editable: true,
        },
        {

            width: 200,
            renderCell: ({ row }) => (
                <Button
                    variant="contained"
                    color="secondary"
                    size="small"
                    onClick={() => handleDelete(row.id)}
                >
                    Xóa
                </Button>
            ),
        }
    ]
    return (
        <div>
            <Typography
                variant="h2"
                fontWeight="bold"
                sx={{ m: " 0 10px 5px 20px" }}
            >
               Xuất kho
            </Typography>
            <div>
                <div>
                    <form onSubmit={handlesubmit}>
                        <div style={{ "textAlign": "left" }} >
                            <div className="card-body" >

                                {showRow ? (
                                    <>
                                        <div className="row">
                                            <div className="col-lg-6">
                                                <div className="form-group">
                                                    <label>
                                                        <b>Ngày lập</b>
                                                    </label>
                                                    <input
                                                        type="date"
                                                        value={checkDatime}
                                                        className="form-control"
                                                        onChange={(e) => setSelectedDate(e.target.value)}
                                                    />
                                                </div>
                                            </div>
                                            
                                            <div className="col-lg-6">
                                                <div className="form-group">
                                                    <label> 
                                                        <b>Ghi chú</b>
                                                    </label>
                                                    <input
                                                        value={description}
                                                        className="form-control"
                                                        onChange={(e) => setdescription (e.target.value)}
                                                    />
                                                </div>
                                            </div>
                                        </div>
                                        <div className="row mt-3">
                                            <h5>
                                                <b>Thêm nguyên liệu</b>
                                            </h5>
                                        </div>
                                        <div className="row">
                                            <div className="col-lg-4">
                                                <div className="form-group">
                                                    <label>
                                                        <b>Nguyên liệu</b>
                                                    </label>
                                                    <Select
                                                        options={ingredients}
                                                        value={selected}
                                                        onChange={handleSelect}
                                                        className="text"
                                                        maxMenuHeight={100}
                                                    />
                                                </div>
                                            </div>
                                            <div className="col-lg-4">
                                                <div className="form-group">
                                                    <label>
                                                        <b>Số lượng</b>
                                                    </label>
                                                    <input
                                                        type="number"
                                                        className="form-control"
                                                        name="actualQuantity"
                                                        value={newIngredient.actualQuantity}
                                                        onChange={handleInputChange}
                                                    />
                                                </div>
                                            </div>
                                            {/* <div className="col-lg-4">
                                                <div className="form-group">
                                                    <label>
                                                        <b>Số lượng chênh lệch</b>
                                                    </label>
                                                    <input
                                                    type="number"
                                                        className="form-control"
                                                        name="discrepancyQuantity"
                                                        value={newIngredient.discrepancyQuantity}
                                                        onChange={handleInputChange}
                                                    />
                                                </div>
                                            </div> */}

                                        </div>
                                        <div className="row justify-content-end align-items-end " >

                                            <div className="col-lg-4 d-flex">
                                                <div className="form-group mt-4 mr-2">
                                                    <button className="btn btn-success" onClick={handleadd} type="submit">
                                                        Thêm
                                                    </button>
                                                </div>
                                                <div className="form-group mt-4 mx-2">
                                                    <button className="btn btn-success" onClick={handleSave} type="submit">
                                                        Lưu
                                                    </button>
                                                </div>
                                            </div>
                                        </div>


                                    </>) : (<div className="row">
                                        
                                        <div className="col-lg-12">
                                            <div className="form-group">
                                                <label><b>Ngày lập</b></label>
                                                <input type="date" onChange={SelectDate} value={checkDatime} className="form-control" required></input>
                                            </div>
                                        </div>
                                        <div className="col-lg-12">
                                            <div className="form-group">
                                                <label ><b>Ghi chú </b></label>
                                                <input value={description} onChange={SelectDes} className="form-control"></input>
                                            </div>
                                        </div>

                                    </div>)}
                                <div className="col-lg-12 d-flex flex-row mt-3">
                                    <div className="form-group">
                                        <Link to="/MrSoai/ware" className="btn btn-danger">Thoát</Link>
                                    </div>  
                                    <div className="form-group mx-2">
                                        <button className="btn btn-success" type="submit">Tạo</button>
                                    </div>
                                </div>
                            </div>
                        </div>

                    </form> 
                </div>
                <div>
                    <Box sx={{ height: 250, width: '100%' }} display="flex" justifyContent="space-between">
                        <DataGrid
                            rows={rows}
                            columns={columns}
                            initialState={{
                                pagination: {
                                    paginationModel: {
                                        pageSize: 5,
                                    },
                                },
                            }}
                            onEditCellChangeCommitted={handleDataChange}
                            pageSizeOptions={[5]}

                            disableRowSelectionOnClick
                        />
                    </Box>
                </div>
            </div>
        </div>
    );
}