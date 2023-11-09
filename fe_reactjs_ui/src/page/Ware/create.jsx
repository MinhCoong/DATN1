import { Box, Button, Typography } from "@mui/material";
import { DataGrid } from "@mui/x-data-grid";
import { useEffect, useState } from "react";
import './create.css';
import { Link } from "react-router-dom";
import Select from 'react-select';
import axios from "axios";

export default function CreateWare() {
    const [showRow, setShowRow] = useState(false);
    const [receiptDate, setSelectedDate] = useState('');
    const [totalValue, setSelectedDes] = useState(0);
    const [selectedOption, setSelectedOption] = useState(null);
    const [selected, setSelected] = useState(null);
    const [suppliers, setSuppliers] = useState("");
    const [userId,setuserId] = useState(localStorage.getItem("userId"))

    const [status] = useState(false)
    const [data, setData] = useState([]);
    const [ingredients, setIngredients] = useState("")
    const [ingredientList, setingredientList] = useState("")
    const [token,settoken] = useState(localStorage.getItem("token"))
    const [newIngredient, setNewIngredient] = useState({
        ingredientsId: "",
        purchasePrice: "",
        quantity: "",
        subtotal: "",
    }); 
    const [rows, setRows] = useState([]);
    const handleShow = (e) => {
        e.preventDefault()
        setShowRow(!showRow)
    }
    const handleInputChange = (event) => {
        const { name, value } = event.target;
        let newQuantity = newIngredient.quantity;
        let newPurchasePrice = newIngredient.purchasePrice;
        let newSubtotal = newQuantity * newPurchasePrice;
        if (name === 'quantity') {
            newQuantity = value;
            newSubtotal = newQuantity * newPurchasePrice;
        } else if (name === 'purchasePrice') {
            newPurchasePrice = value;
            newSubtotal = newQuantity * newPurchasePrice;
        }
        setNewIngredient({
            ...newIngredient,
            [name]: value,
            subtotal: newSubtotal,
        });
    };
    const SelectDate = (event) => {
        setSelectedDate(event.target.value);
    };
    const SelectDes = (event) => {
        setSelectedDes(event.target.value);
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
          purchasePrice: "",
          quantity: "",
          subtotal: "",
        });
      };
    const handleDelete = (id) => {
        setRows(rows.filter((row) => row.id !== id));
    };
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
    const handlesubmit = (e) => {
        e.preventDefault();
        setShowRow(!showRow)
        const empdata = {
            "userId": userId,
            "suppliersId": selectedOption.value,
            "totalValue": totalValue,
            "receiptDate": receiptDate,
            "status": status

        }
        fetch("https://localhost:7245/Admin/v1/api/InventoryReceipts", {
            method: "POST",
            headers: { "content-type": "application/json" },
            body: JSON.stringify(empdata)
        }).then((res) => {
            alert('Bạn muốn thêm hóa đơn nhập')

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
            "quantity": item.quantity,
            "purchasePrice": item.purchasePrice,
            "subtotal": item.subtotal,
            "status": item.status
        }));
        fetch("https://localhost:7245/Admin/v1/api/InventoryReceiptDetails", {
            method: "POST",
            headers: { "content-type": "application/json" },
            body: JSON.stringify(empdata)
        }).then((res) => {
            alert('Dữ liệu đã được lưu thành công')

        }).catch((err) => {
            console.log(err.message)
        })
        console.log(rows)
    }
    useEffect(() => {
        axios.get("https://localhost:7245/Admin/v1/api/Suppliers",{ headers: { 'Authorization': `Bearer ${token}`}})
            .then(response => {
                const suppliers = response.data.map(item => ({
                    value: item.id,
                    label: item.supplierName
                }));
                setSuppliers(suppliers);
            })
            .catch(error => {
                console.error(error);
            });
    }, []);
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
            field: 'quantity',
            headerName: 'Số lượng',

            width: 150,
            editable: true,
        },
        {
            field: 'purchasePrice',
            headerName: 'Giá mua',
            width: 170,
            editable: true,
            renderCell: (params) => {
                return (
                  <p>
                    {new Intl.NumberFormat("vi-VN", {
                      style: "currency",
                      currency: "VND",
                    }).format(params.value)}
                  </p>
                );
              },
        },
        {
            field: 'subtotal',
            headerName: 'Tổng',
            width: 230,
            editable: true,
            renderCell: (params) => {
                return (
                  <p>
                    {new Intl.NumberFormat("vi-VN", {
                      style: "currency",
                      currency: "VND",
                    }).format(params.value)}
                  </p>
                );
              },
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
                Thêm Hóa đơn
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
                                                        value={receiptDate}
                                                        className="form-control"
                                                        onChange={(e) => setSelectedDate(e.target.value)}
                                                    />
                                                </div>
                                            </div>
                                            <div className="col-lg-6">
                                                <div className="form-group">
                                                    <label fontWeight="bold">Nhà cung cấp</label>
                                                    <Select
                                                        options={suppliers}
                                                        value={selectedOption}
                                                        onChange={handleSelectChange}
                                                        className="text"
                                                    />
                                                </div>
                                            </div>
                                            {/* <div className="col-lg-4">
                                                <div className="form-group">
                                                    <label> 
                                                        <b>Ghi chú</b>
                                                    </label>
                                                    <input
                                                        value={totalValue}
                                                        className="form-control"
                                                        onChange={(e) => setSelectedDes(e.target.value)}
                                                    />
                                                </div>
                                            </div> */}
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
                                                    />
                                                </div>
                                            </div>
                                            <div className="col-lg-4">
                                                <div className="form-group">
                                                    <label>
                                                        <b>Số lượng</b>
                                                    </label>
                                                    <input required
                                                        type="number"
                                                        className="form-control"
                                                        name="quantity"
                                                        value={newIngredient.quantity}
                                                        onChange={handleInputChange}
                                                    />
                                                </div>
                                            </div>
                                            <div className="col-lg-4">
                                                <div className="form-group">
                                                    <label>
                                                        <b>Giá mua</b>
                                                    </label>
                                                    <input required
                                                        className="form-control"
                                                        name="purchasePrice"
                                                        value={newIngredient.purchasePrice}
                                                        onChange={handleInputChange}
                                                    />
                                                </div>
                                            </div>

                                        </div>
                                        <div className="row align-items-end">

                                            <div className="col-lg-4">
                                                <div className="form-group">
                                                    <label>
                                                        <b>Tổng</b>
                                                    </label>
                                                    <input
                                                        className="form-control"
                                                        name="subtotal"
                                                        value={newIngredient.subtotal}
                                                        onChange={handleInputChange}
                                                    />
                                                </div>
                                            </div>
                                            <div className="col-lg-4 d-flex">
                                                <div className="form-group mt-4 mr-2">
                                                    <button className="btn btn-success" onClick={handleadd} type="submit">
                                                        Thêm
                                                    </button>
                                                </div>
                                                <div className="form-group mt-4 mx-2">
                                                    <button className="btn btn-success" onClick={handleSave} type="submit">
                                                        Save
                                                    </button>
                                                </div>
                                            </div>
                                        </div>


                                    </>) : (<div className="row">
                                        <div className="col-lg-12">
                                            <div className="form-group">
                                                <label fontWeight="bold">Nhà cung cấp</label>
                                                <Select
                                                    options={suppliers}
                                                    value={selectedOption}
                                                    onChange={handleSelectChange}
                                                    className="text"
                                                />
                                            </div>
                                        </div>
                                        <div className="col-lg-12">
                                            <div className="form-group">
                                                <label><b>Ngày lập</b></label>
                                                <input required type="date" onChange={SelectDate} value={receiptDate} className="form-control"></input>
                                            </div>
                                        </div>
                                        {/* <div className="col-lg-12">
                                            <div className="form-group">
                                                <label ><b>Ghi chú </b></label>
                                                <input value={totalValue} onChange={SelectDes} className="form-control"></input>
                                            </div>
                                        </div> */}

                                    </div>)}
                                <div className="col-lg-12 d-flex flex-row mt-3">
                                    <div className="form-group">
                                        <Link to="/MrSoai/ware" className="btn btn-danger">Back</Link>
                                    </div>
                                    <div className="form-group mx-2">
                                        <button className="btn btn-success" type="submit">Tạo</button>
                                    </div>
                                    {/* <div className="form-group  mx-2">
                                        <button className="btn btn-success" onClick={handleShow} type="submit">...</button>
                                    </div> */}
                                </div>
                            </div>
                        </div>

                    </form>
                </div>
                <div>
                    <Box sx={{ height: '50vh', width: '100%' }} display="flex" justifyContent="space-between">
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
            </div>
        </div>
    );
}