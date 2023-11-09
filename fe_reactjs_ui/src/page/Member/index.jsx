import * as React from 'react';
import { Box, Button, colors, useTheme } from '@mui/material';
import { DataGrid, GridColDef, } from '@mui/x-data-grid';
import { tokens } from '../../theme';
import { Typography } from '@mui/material';
import { Link, useNavigate } from 'react-router-dom';
import { BsPersonFillAdd, BsFillGearFill } from 'react-icons/bs'
import { AiFillDelete } from "react-icons/ai";
import { useState } from 'react';
import { useEffect } from 'react';
import axios from 'axios';

export default function Member() {
    const theme = useTheme();
    const color = tokens(theme.palette.mode);
    const [data, setData] = useState([]);
    const [token,settoken] = useState(localStorage.getItem("token"))
    const history = useNavigate();
    const handleEditClick = (id) => {
        history(`/MrSoai/editM/${id}`, { state: { data: data.filter(item => item.id === id)[0] } });
    };
    const handleEdit = (id) => {
        history(`/MrSoai/editMT/${id}`, { state: { data: data.filter(item => item.id === id)[0] } });
    };
    const columns: GridColDef[] =
    [
        {
            field: 'firstName',
            headerName: 'Họ',
            width: 100,
            editable: true,
            flex:1
        },
        {
            field: 'lastName',
            headerName: 'Tên',
            width: 100,
            editable: true,
            flex:1
        },
        {
            field: 'phoneNumber',
            headerName: 'SDT',
           
            width: 120,
           
            flex:1
        },
        {
            field: 'userName',
            headerName: "Tài khoản",
            width: 150,
           
            flex:1
        },
        {
            field: 'authenPhoneNumberId',
            headerName: "Chức vụ",
            width: 150,
            editable: true,
            flex:1
        },
        {
            field: 'button',
            headerName: 'Chức năng',
            width: 340,
            renderCell: ({ row: { access, id } }) => {
                return (
                    <Box display="flex" justifyContent="space-between" alignItems="center">
                       
                       <Button
                            onClick={() => {
                                handleEditClick(id)
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
                                handleEdit(id)
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
                            Thông tin
                        </Button>
                        <Box paddingRight="3px"></Box>
                        <Button
                        onClick={() => {
                            if (window.confirm("Bạn có chắc chắn muốn xóa")) {
                                axios.delete(`https://localhost:7245/Admin/v1/api/Users/${id}`,{ headers: { 'Authorization': `Bearer ${token}`}})
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
    useEffect(() => {
        axios.get('https://localhost:7245/Admin/v1/api/Users/Insider',{ headers: { 'Authorization': `Bearer ${token}`}})
            .then(response => {
                setData(response.data);
            })
            .catch(error => {
                console.log(error);
            });
    }, []);
    return (
        <Box m="20px">
            <Box mb="30px" >
                <Typography
                    variant="h2"
                    color={color.grey[100]}
                    fontWeight="bold"
                    sx={{ m: " 0 0 5px 0" }}
                >
                    Nhân viên
                </Typography>
            </Box>
            <Box m="10px">
                <Link to="/MrSoai/createM">
                    <Button
                        sx={{
                            backgroundColor: color.blueAccent[700],
                            color: color.grey[100],
                            fontSize: "14px",
                            fontWeight: "bold",
                            padding: "10px 20px",
                        }}
                        startIcon={<BsPersonFillAdd />}
                    >
                        Thêm
                    </Button>
                </Link>
            </Box>
            <Box sx={{ height: '70vh', width: '100%' }} >
                <DataGrid
                    rows={data}
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