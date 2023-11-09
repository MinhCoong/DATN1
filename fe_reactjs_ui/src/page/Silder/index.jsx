import { useEffect, React, useState } from 'react';
import { Box, Button, useTheme, colors } from '@mui/material';
import { DataGrid, GridColDef, } from '@mui/x-data-grid';
import { tokens } from '../../theme';
import { Typography } from '@mui/material';
import { Link, useNavigate } from 'react-router-dom';
import { AiFillDelete } from "react-icons/ai";
import { MdAddCircle } from "react-icons/md";
import axios from 'axios';
import moment from "moment";

export default function Slider() {
    const theme = useTheme();
    const color = tokens(theme.palette.mode);
    const [data, setData] = useState([]);
    const history = useNavigate();
    const [dataTrue, setDataTrue] = useState([]);
    const [token,settoken] = useState(localStorage.getItem("token"))
    const columns: GridColDef[] = [
        {
            flex:1,
            field: 'imageSlider',
            headerName: 'Hình ảnh',
            width: 130,
            editable: true,
            renderCell: ({ row }) => {  
                const imageUrl = row.imageSlider;
                return (
                    <div>
                        <img src={`https://localhost:7245/uploadImgSlider/${imageUrl}`} width="40px" height="40px"/>
                    </div>
                );
            }
        },
        {
            flex:1,
            field: 'dateAdd',
            headerName: 'Ngày thêm',
            width: 430,
            editable: true,
            renderCell: (params) => {
                return (
                    <p>{moment(params.value).format("YYYY-MM-DD, hh:mm:ss")}</p>
                )
            }
        },
        {
            field: 'button',
            headerName: 'Chức năng',
            width: 200,
            renderCell: ({ row: { access, id } }) => {
                return (
                    <Box display="flex" justifyContent="space-between" alignItems="center">

                        <Box paddingRight="3px"></Box>
                        <Button
                            onClick={() => {
                                if (window.confirm("Bạn có chắc chắn muốn xóa")) {
                                    axios.delete(`https://localhost:7245/Admin/v1/api/Sliders/${id}`,{ headers: { 'Authorization': `Bearer ${token}`}})
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
    const handleEditClick = (id) => {
        history(`/MrSoai/editSlider/${id}`, { state: { data: data.filter(item => item.id === id)[0] } });
    };
    useEffect(() => {

        axios.get('https://localhost:7245/Admin/v1/api/Sliders',{ headers: { 'Authorization': `Bearer ${token}`}})
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


    return (
        <Box m="20px">
            <Box mb="30px" >
                <Typography
                    variant="h2"
                    color={color.grey[100]}
                    fontWeight="bold"
                    sx={{ m: " 0 0 5px 0" }}
                >
                    Slider
                </Typography>
            </Box>
            <Box m="10px">
                <Link to="/MrSoai/createSlider">
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