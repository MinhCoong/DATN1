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


export default function Quantums() {
    const theme = useTheme();
    const color = tokens(theme.palette.mode);
    const [data, setData] = useState([]);
    const [dataTrue, setDataTrue] = useState([]);
    const history = useNavigate();
    const [token,settoken] = useState(localStorage.getItem("token"))
    useEffect(() => {
        axios.get('https://localhost:7245/api/Quantums',)
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
        history(`/MrSoai/editQ/${id}`, { state: { data: data.filter(item => item.id === id)[0] } });
       // history(`/editT/${id}`);
    };
    const columns: GridColDef[] = [
        { field: 'id', headerName: 'ID', width: 90 },
        {
            
            field: 'productName',
            headerName: 'Tên sản phẩm',
            width: 130,
        },
        {
            field: 'ingredients',
            headerName: 'Nguyên liệu ',
            width: 110,
            editable: true,
            valueGetter: (params) => {
                const foreignKey = params.row.ingredients;
                return foreignKey.ingredientName;
            },
        },
        {
            
            field: 'quantity',
            headerName: 'Số lượng',
            width: 130,
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
                                    axios.delete(`https://localhost:7245/api/Quantums/${id}`,)
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
                    Định lượng
                </Typography>
            </Box>
            <Box m="10px">
                <Link to="/MrSoai/createQ">
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
