import * as React from 'react';
import { Box, Button, useTheme } from '@mui/material';
import { DataGrid, GridColDef, } from '@mui/x-data-grid';
import { tokens } from '../../theme';
import { Typography } from '@mui/material';
import { Link } from 'react-router-dom';
import { BsPersonFillAdd,  } from 'react-icons/bs'
import { useState } from 'react';
import { useEffect } from 'react';
import axios from 'axios';
import moment from "moment";

export default function Customer() {
    const theme = useTheme();
    const colors = tokens(theme.palette.mode);
    const [data, setData] = useState([]);
    const [token,settoken] = useState(localStorage.getItem("token"))
    const columns: GridColDef[] =
    [
        {
            field: 'firstName',
            headerName: 'Họ',
            width: 130,
            editable: true,
            flex:1
        },
        {
            field: 'lastName',
            headerName: 'Tên',
            width: 130,
            editable: true,
            flex:1
        },
        {
            field: 'phoneNumber',
            headerName: 'SDT',
            width: 130,
            editable: true,
            flex:1
        },
        {
            field: 'point',
            headerName: "Tích điểm",
            width: 150,
            editable: true,
            flex:1
        },
        {
            field: 'registerDatetime',
            headerName: "Ngày đăng ký",
            width: 150,
            editable: true,
            renderCell: (params) => {
                return (
                    <p>{moment(params.value).format("YYYY-MM-DD, hh:mm:ss")}</p>
                )
            }
        
        },
    ];
    useEffect(() => {
        axios.get('https://localhost:7245/Admin/v1/api/Users/Customer',{ headers: { 'Authorization': `Bearer ${token}`}})
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
                    color={colors.grey[100]}
                    fontWeight="bold"
                    sx={{ m: " 0 0 5px 0" }}
                >
                    Khách hàng
                </Typography>
            </Box>
           
            <Box sx={{ height: '80vh', width: '100%' }} >
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