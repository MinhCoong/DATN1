import * as React from 'react';
import { Box, Button, useTheme, colors } from '@mui/material';
import { DataGrid, GridColDef, } from '@mui/x-data-grid';
import { tokens } from '../../theme';
import { Typography } from '@mui/material';
import { Link, useNavigate } from 'react-router-dom';
import { BsFillGearFill } from 'react-icons/bs'
import { AiFillDelete } from "react-icons/ai";
import { MdAddCircle } from "react-icons/md";
import { useState } from 'react';
import { useEffect } from 'react';  
import axios from 'axios';
import moment from "moment";

export default function Suppliers() {
    const theme = useTheme();
    const color = tokens(theme.palette.mode);
    const [data, setData] = useState([]);
    const [dataTrue, setDataTrue] = useState([]);
    const history = useNavigate();
    const [token,settoken] = useState(localStorage.getItem("token"))
    useEffect(() => {
        axios.get('https://localhost:7245/Admin/v1/api/Suppliers',{ headers: { 'Authorization': `Bearer ${token}`}})
            .then(response => {
                setData(response.data);
            })
            .catch(error => {
                console.log(error);
            });
    }, []);

    useEffect(() => {
        let arr = [];
        data.map((item) => {
            if (item.status) {
                arr.push(item)
            }
        })
        setDataTrue(arr);

    }, [data])
    const handleEditClick = (id) => {
        history(`/MrSoai/editSuppliers/${id}`, { state: { data: data.filter(item => item.id === id)[0] } });
       // history(`/editT/${id}`);
    };
    const columns: GridColDef[] = [
        {
            field: 'supplierName',
            headerName: 'Nhà cung cấp',
            width: 130,
            editable: true,
            flex:1
        },
        {
            field: 'supplierAddress',
            headerName: 'Địa chỉ',
            width: 130,
            editable: true,
            flex:1
        },
        {
            field: 'supplierPhoneNumber',
            headerName: 'SDT',
            width: 130,
            editable: true,
            flex:1
        },
        {
            field: 'supplierEmail',
            headerName: 'Email',
            width: 130,
            editable: true,
            flex:1
        },
        {
            field: 'button',
            headerName: 'Chức năng',
            width: 200,
            renderCell: ({ row: { access, id } }) => {
                return (
                    <Box display="flex" justifyContent="space-between" alignItems="center">
                        
                            <Button
                              onClick={() => {
                                handleEditClick(id)
                               //setShowFormEdit(true)
                           }}
                                sx={{
                                    backgroundColor: colors.green[900],
                                    color: colors.grey[100],
                                    fontSize: "14px",
                                    fontWeight: "bold",
                                    padding: "5px 10px",
                                }}
                                startIcon={<BsFillGearFill />}
                            >
                                Sửa
                            </Button>
                        <Box paddingRight="3px"></Box>
                        <Button
                            onClick={() => {
                                if (window.confirm("Bạn có chắc chắn muốn xóa")) {
                                    axios.delete(`https://localhost:7245/Admin/v1/api/Suppliers/${id}`,{ headers: { 'Authorization': `Bearer ${token}`}})
                                        .then(response => {
                                            console.log(response.data);
                                            window.location.reload();
                                        })
                                        .catch(error => {
                                            console.log(error);
                                        });
                                }
                            }}
                            sx={{
                                backgroundColor: colors.red[900],
                                color: colors.grey[100],
                                fontSize: "14px",
                                fontWeight: "bold",
                                padding: "5px 10px",
                            }}
                            startIcon={<AiFillDelete />}
                        >
                            Xóa
                        </Button>

                    </Box>
                );
            }
        },
    ];
    return (
        <Box m="20px">
            <Box mb="30px" >
                <Typography
                    variant="h2"
                    color={color.grey[100]}
                    fontWeight="bold"
                    sx={{ m: " 0 0 5px 0" }}
                >
                    Nhà cung cấp
                </Typography>
            </Box>
            <Box m="10px">
                <Link to="/MrSoai/createSuppliers">
                    <Button
                        sx={{
                            backgroundColor: color.blueAccent[700],
                            color: color.grey[100],
                            fontSize: "14px",
                            fontWeight: "bold",
                            padding: "10px 20px",
                        }}
                        startIcon={<MdAddCircle />}
                    >
                        Thêm
                    </Button>
                </Link>
            </Box>
            <Box sx={{ height: '70vh', width: '100%' }} display="flex" justifyContent="space-between">
                <DataGrid
                    rows={dataTrue}
                    columns={columns}
                    initialState={{
                        pagination: {
                            paginationModel: {
                                pageSize: 15,
                            },
                        },
                    }}
                    pageSizeOptions={[15]}

                    disableRowSelectionOnClick
                />
            </Box>
        </Box>
    );
}