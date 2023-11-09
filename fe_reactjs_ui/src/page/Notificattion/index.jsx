import * as React from 'react';
import { Box, Button, useTheme,colors } from '@mui/material';
import { DataGrid, GridColDef,  } from '@mui/x-data-grid';
import { tokens } from '../../theme';
import { Typography } from '@mui/material';
import { AiFillDelete } from 'react-icons/ai';
import { Link, useNavigate } from 'react-router-dom';
import { MdAddCircle } from 'react-icons/md';
import axios from 'axios';
import { useEffect } from 'react';
import { useState } from 'react';
import moment from "moment";
export default function Notification() {
    const theme = useTheme();
    const color = tokens(theme.palette.mode);
    const [data, setData] = useState([]);
    const [dataTrue, setDataTrue] = useState([]);
    const [token,settoken] = useState(localStorage.getItem("token"))
    useEffect(() => {

        axios.get('https://localhost:7245/Admin/v1/api/Notifications',{ headers: { 'Authorization': `Bearer ${token}`}})
            .then(async response => {
                setData(await response.data);
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
    const columns: GridColDef[] = [
        
        {
            field: 'title',
            headerName: 'Tiêu đề',
            width: 200,
            editable: true,
            flex:1
        },
        {
            field: 'createdAt',
            headerName: 'Ngày lập',
            width: 200,
            editable: true,
            flex:1,
            renderCell: (params) => {
                return (
                    <p>{moment(params.value).format("YYYY-MM-DD, hh:mm:ss")}</p>
                )
            }
        },
        {
            field: 'body',
            headerName: "Nội dung",
            width:400,
            editable: true,
            flex:1
        },
        
        {
            headerName: "Chức năng",
            width: 150,
            renderCell: ({ row: { access, id } }) => {
                return (
                    <Box display="flex" justifyContent="space-between" alignItems="center">
                        <Box paddingRight="3px"></Box>
                        <Button
                            onClick={() => {
                                if (window.confirm("Bạn có chắc chắn muốn xóa")) {
                                    axios.delete(`https://localhost:7245/Admin/v1/api/Notifications?id=${id}`,{ headers: { 'Authorization': `Bearer ${token}`}})
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
                    // })
                );
            }
        },
    ];
    return (
        <Box  m="20px">
            <Box mb="30px" >
                <Typography 
                    variant="h2"
                    color={colors.grey[100]}
                    fontWeight="bold"
                    sx={{ m: " 0 0 5px 0" }}
                >
                    Thông báo
                </Typography>
            </Box>
            <Box m="10px">
                <Link to="/MrSoai/createNoti">
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
