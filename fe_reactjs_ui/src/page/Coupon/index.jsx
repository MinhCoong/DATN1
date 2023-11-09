import * as React from 'react';
import { Box, Button, useTheme,colors } from '@mui/material';
import { DataGrid, GridColDef,  } from '@mui/x-data-grid';
import { tokens } from '../../theme';
import { Typography } from '@mui/material';
import { BsFillGearFill } from 'react-icons/bs';
import { AiFillDelete } from 'react-icons/ai';
import { Link, useNavigate } from 'react-router-dom';
import { MdAddCircle } from 'react-icons/md';
import axios from 'axios';
import { useEffect } from 'react';
import { useState } from 'react';
import moment from "moment";

export default function Coupon() {
    const theme = useTheme();
    const color = tokens(theme.palette.mode);
    const [data, setData] = useState([]);
    const [dataTrue, setDataTrue] = useState([]);
    const [token,settoken] = useState(localStorage.getItem("token"))
    const history = useNavigate();
    const handleEditClick = (id) => {
        history(`/MrSoai/editCoupon/${id}`, { state: { data: data.filter(item => item.id === id)[0] } });
    };
    useEffect(() => {

        axios.get('https://localhost:7245/Admin/v1/api/coupon',{ headers: { 'Authorization': `Bearer ${token}`}})
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
    const columns: GridColDef[] = [
        {
            field: 'user',
            headerName: 'Nhân viên',
            width: 100,
            editable: true,
            valueGetter: (params) => {
                const foreignKey = params.row.user;
                return foreignKey.userName;
            },
        },
        {
            flex:1,
            field: 'title',
            headerName: 'Tiêu đề',
            width: 60,
            editable: true,
        },
        {
            field: 'code',
            headerName: 'Mã',
            width: 90,
            editable: true,
            flex:1

        },
        {
            field: 'description',
            headerName: "Ghi chú",
            width:130,
            editable: true,
            flex:1

        },
        {
            field: 'discount',
            headerName: "Giảm giá",
            width:60,
            editable: true,
            flex:1

        },
        {
            field: 'startDate',
            headerName: "Ngày bắt đầu",
            width:100,
            editable: true,
            flex:1,
            renderCell: (params) => {
                return (
                    <p>{moment(params.value).format("YYYY-MM-DD, hh:mm:ss")}</p>
                )
            }
        },
        {
            field: 'endDate',
            headerName: "Ngày kết thúc",
            width:100,
            editable: true,
            flex:1,
            renderCell: (params) => {
                return (
                    <p>{moment(params.value).format("YYYY-MM-DD, hh:mm:ss")}</p>
                )
            }
        },
        {
            field: 'point',
            headerName: "điểm",
            width:70,
            editable: true,
            flex:1
        },
        {
            flex:1,
            field: 'minimumQuantity',
            headerName: "Số lượng tối thiểu",
            width:70,
            editable: true
        },
        {
            field: 'minimumTotla',
            headerName: "Tốn đa giảm",
            width:70,
            editable: true,
            flex:1
        },
        {
            flex:1,
            field: 'image',
            headerName: 'Hình ảnh',
            width: 70,
            editable: true,
            renderCell: ({ row }) => {
                const imageUrl = row.image;
                return (
                    <div>
                        <img src={`https://localhost:7245/couponimages/${imageUrl}`} width="40px" height="40px"/>
                    </div>
                );
            }
        },
        {
            field: 'button',
            headerName: 'Chức năng',
            width: 180,
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
                                if (window.confirm("Bạn có chắc chắn muốn xóa")) {
                                    axios.delete(`https://localhost:7245/Admin/v1/api/coupon/${id}`,{ headers: { 'Authorization': `Bearer ${token}`}})
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
                    Mã khuyến mãi
                </Typography>
            </Box>
            <Box m="10px">
                <Link to="/MrSoai/createCouupon">
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