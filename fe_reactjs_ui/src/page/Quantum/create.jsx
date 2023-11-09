import { useEffect, useState } from "react";
import { Link, useNavigate } from "react-router-dom";
import { Box, Button, Typography, useTheme } from '@mui/material'
import { tokens } from '../../theme';
import Select from 'react-select';
import axios from "axios";
import { DataGrid } from "@mui/x-data-grid";
export default function CreateQ() {
    const theme = useTheme();
    const colors = tokens(theme.palette.mode);
    const [token, settoken] = useState(localStorage.getItem("token"))
    const [productName, setName] = useState("");
    const [toppingName, setTopping] = useState("")
    const [ingredients, setingredients] = useState("");
    const [selectedOption, setSelectedOption] = useState(null);
    const [selected, setSelected] = useState(null);
    const [rows, setRows] = useState([]);
    const [data, setData] = useState([]);
    const [ingredientList, setingredientList] = useState("")
    const [newIngredient, setNewIngredient] = useState({
        ingredientsId: "",
        quantity: "",
    });

    const handlesubmit = (e) => {
        e.preventDefault();

        const listIngredientAndQuantity = rows.map(item => ({
            ingredientId: item.ingredientsId,
            quantity: item.quantity
          }));
        const quantums = {
            productName: selectedOption.label,
            listIngredientAndQuantity: listIngredientAndQuantity
        }
        fetch("https://localhost:7245/api/Quantums", {
            method: "POST",
            headers: { "content-type": "application/json" },
            body: JSON.stringify(quantums)
        }).then((res) => {
            alert('Thêm định lượng thành công')
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
        axios.get("https://localhost:7245/Admin/v1/api/product", { headers: { 'Authorization': `Bearer ${token}` } })
            .then(response => {
                const product = response.data.map(item => ({
                    value: item.id,
                    label: item.productName
                }));
                setName(product);
            })
            .catch(error => {
                console.error(error);
            });
    });
    const options = [...toppingName, ...productName];
    useEffect(() => {
        axios.get("https://localhost:7245/Admin/v1/api/Ingredients")
            .then(response => {
                const ingredients = response.data.map(item => ({
                    value: item.id,
                    label: item.ingredientName
                }));
                const data = response.data
                setingredients(ingredients);
                setingredientList(data)
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
        setNewIngredient({
            ...newIngredient,
            ingredientsId: value,
        });
    };
    const handleDataChange = (params) => {
        setData(params.row);
    };
    const handleDelete = (id) => {
        setRows(rows.filter((row) => row.id !== id));
    };
    const handleInputChange = (event) => {
        const { name, value } = event.target;
        setNewIngredient({
            ...newIngredient,
            [name]: value,
        });
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
            quantity: "",
        });
    };
    const columns: GridColDef[] = [

        {
            field: 'ingredientName',
            headerName: 'Tên nguyên liệu',
            width: 280,
            editable: true,

        },
        {
            field: 'quantity',
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
                color={colors.grey[100]}
                fontWeight="bold"
                sx={{ m: " 0 10px 5px 20px" }}
            >
                Thêm định lượng
            </Typography>
            <form onSubmit={handlesubmit}>
                <div style={{ "textAlign": "left" }}>
                    <div className="card-body">
                        <div className="row">
                            <div className="col-lg-12">
                                <div className="form-group">
                                    <label fontWeight="bold">Tên sản phẩm</label>
                                    <Select
                                    required
                                        options={options}
                                        value={selectedOption}
                                        onChange={handleSelectChange}
                                        className="text"
                                       
                                        maxMenuHeight={150}
                                    />
                                </div>
                            </div>
                            <div className="col-lg-6">
                                <div className="form-group">
                                    <label fontWeight="bold">Nguyên liệu</label>
                                    <Select
                                    required
                                        options={ingredients}
                                        value={selected}
                                        onChange={handleSelect}
                                        className="text"
                                        maxMenuHeight={100}
                                    />
                                </div>
                            </div>
                            <div className="col-lg-6">
                                <div className="form-group">
                                    <label>
                                        <b>Định lượng</b>
                                    </label>
                                    <input
                                    required
                                        type="number"
                                        className="form-control"
                                        name="quantity"
                                        value={newIngredient.quantity}
                                        onChange={handleInputChange}
                                    />
                                </div>
                            </div>
                            <div className="form-group mt-4 mr-2 mb-2">
                                <button className="btn btn-success" onClick={handleadd} type="submit">
                                    Thêm NL
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
                                    <Link to="/MrSoai/quantums" className="btn btn-danger">Thoát</Link>
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
