import { useEffect, useState } from "react";
import { Link, useNavigate } from "react-router-dom";
import { Box, Button, Typography, useTheme } from '@mui/material'
import { tokens } from '../../theme';
import Select from 'react-select';
import axios from "axios";
import { DataGrid } from "@mui/x-data-grid";
export default function CreateCT() {
    const theme = useTheme();
    const colors = tokens(theme.palette.mode);
    const [token, settoken] = useState(localStorage.getItem("token"))
   
    const [toppingName, setTopping] = useState("")
    const [cateogry, setcateogry] = useState("");
    const [selectedOption, setSelectedOption] = useState(null);
    const [selected, setSelected] = useState(null);
    const [rows, setRows] = useState([]);
    const [data, setData] = useState([]);
    const [category, setcategory] = useState("")
    const [newcategory, setNewcategory] = useState({
        listint: "",
        
    });

    const handlesubmit = (e) => {
        e.preventDefault();
       
        const list = rows.map(item => item.listint);
        const quantums = {
            toppingId: selectedOption.value,
            listint: list
        }
        console.log(list)
        fetch("https://localhost:7245/api/CategoryAndToppings", {
            method: "POST",
            headers: { "content-type": "application/json", 'Authorization': `Bearer ${token}` },
            body: JSON.stringify(quantums)
        }).then((res) => {
            alert('Thêm loại topping thành công')
        }).catch((err) => {
            console.log(err.message)
        })
    }
    useEffect(() => {
        axios.get('https://localhost:7245/Admin/v1/api/topping', { headers: { 'Authorization': `Bearer ${token}` } })
            .then(response => {
                const topping = response.data.map(item => ({
                    value: item.id,
                    label: item.toppingName
                }));
                setTopping(topping);
            })
            .catch(error => {
                console.log(error);
            });
    });
    useEffect(() => {
        axios.get('https://localhost:7245/Admin/v1/api/category', { headers: { 'Authorization': `Bearer ${token}`}})
            .then(response => {
                const category = response.data.map(item => ({
                    value: item.id,
                    label: item.categoryName
                }));
                const data = response.data
                setcateogry(category);
                setcategory(data)
            })
            .catch(error => {
                console.error(error);
            });
    });
    const handleSelectChange = selectedOption => {
        setSelectedOption(selectedOption);
    };
    const handleSelect = (select) => {
        setSelected(select);
        const { value } = select;
        setNewcategory({
            ...newcategory,
            listint: value,
        });
    };
    const handleDataChange = (params) => {
        setData(params.row);
    };
    const handleDelete = (id) => {
        setRows(rows.filter((row) => row.id !== id));
    };
    const handleadd = (event) => {
        event.preventDefault();
        const ingredient = category.find((item) => item.id === newcategory.listint);
        const newRow = {
            ...newcategory,
            id: new Date().getTime(),
            categoryName: ingredient ? ingredient.categoryName : "",
        };
        setRows([...rows, newRow]);
        setNewcategory({
            listint: "",
        });
    };
    const columns: GridColDef[] = [

        {
            field: 'categoryName',
            headerName: 'Tên sản phẩm',
            width: 280,
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
                color={colors.grey[100]}
                fontWeight="bold"
                sx={{ m: " 0 10px 5px 20px" }}
            >
                Thêm loại topping
            </Typography>
            <form onSubmit={handlesubmit}>
                <div style={{ "textAlign": "left" }}>
                    <div className="card-body">
                        <div className="row">
                            <div className="col-lg-12">
                                <div className="form-group">
                                    <label fontWeight="bold">Tên topping</label>
                                    <Select
                                    required
                                        options={toppingName}
                                        value={selectedOption}
                                        onChange={handleSelectChange}
                                        className="text"
                                       
                                        maxMenuHeight={150}
                                    />
                                </div>
                            </div>
                            <div className="col-lg-12">
                                <div className="form-group">
                                    <label fontWeight="bold">Loại sản phẩm</label>
                                    <Select
                                    required
                                        options={cateogry}
                                        value={selected}
                                        onChange={handleSelect}
                                        className="text"
                                        maxMenuHeight={100}
                                    />
                                </div>
                            </div>
                           
                            <div className="form-group mt-4 mr-2 mb-2">
                                <button className="btn btn-success" onClick={handleadd} type="submit">
                                    Thêm loại
                                </button>
                            </div>
                            <div>
                                <Box sx={{ height: '40vh', width: '100%' }} display="flex" justifyContent="space-between">
                                    <DataGrid
                                        rows={rows}
                                        columns={columns}
                                        initialState={{
                                            pagination: {
                                                paginationModel: {
                                                    pageSize: 10,
                                                },
                                            },
                                        }}
                                        onEditCellChangeCommitted={handleDataChange}
                                        pageSizeOptions={[10]}

                                        disableRowSelectionOnClick
                                    />
                                </Box>
                            </div>
                            <div className="col-lg-12 d-flex flex-row mt-4">
                                <div className="form-group">
                                    <button className="btn btn-success" type="submit">Lưu</button>

                                </div>
                                <div className="mx-3">
                                    <Link to="/MrSoai/categorytopping" className="btn btn-danger">Thoát</Link>
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
