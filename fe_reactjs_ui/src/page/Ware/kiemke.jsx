import { useTheme } from '@emotion/react';
import { Box, Button, Typography, colors, Dialog, DialogActions, DialogContent, DialogTitle } from '@mui/material'
import React from 'react'
import { tokens } from '../../theme';
import { DataGrid } from '@mui/x-data-grid';
import { Link } from 'react-router-dom';
import { useState } from 'react';
import { useEffect } from 'react';
import axios from 'axios';
import moment from "moment";
export default function Kiemke() {
    const theme = useTheme();
    const color = tokens(theme.palette.mode);
    const [openDialog, setOpenDialog] = useState(false);
    const [detail, setDetail] = useState(null);
    const [startDate, setStart] = useState('')
    const [userId,setuserId] = useState(localStorage.getItem("userId"))
    const handleCloseDialog = () => {
        setOpenDialog(false);
    };
    const handleOpenDialog = (id) => {
        setOpenDialog(true);
        axios
            .get("https://localhost:7245/api/InventoryAuditings/" + id)
            .then(async (response) => {
                setDetail(response.data);
            })
            .catch((error) => {
                console.log(error);
            });
    }
    const [data, setData] = useState('')
    useEffect(() => {
        axios.get('https://localhost:7245/api/InventoryAuditings')
            .then(response => {
                setData(response.data);
            })
            .catch(error => {
                console.log(error);
            });
    }, []);
    const handSearch = () => {
        const data = {
            'dateTime': startDate,
            'userId': userId
        }
        fetch("https://localhost:7245/api/InventoryAuditings/InventoryAuditing?dateTime="+startDate+"&userId="+userId, {
            method: "POST",
            headers: { "content-type": "application/json" },
            body: JSON.stringify(data)
        }).then((res) => {
            alert('Tạo kiểm kê thành công')
        }).catch((err) => {
            console.log(err.message)
        })
        axios.get('https://localhost:7245/api/InventoryAuditings')
            .then(response => {
                setData(response.data);
            })
            .catch(error => {
                console.log(error);
            });
      }
    const columns: GridColDef[] = [

        {
            field: 'user',
            headerName: 'Họ',
            width: 150,
            editable: true,
            valueGetter: (params) => {
                const foreignKey = params.row.user;
                return foreignKey.firstName;
            },
            flex: 1
        },
        {
            field: 'userId',
            headerName: 'Tên',
            width: 250,
            editable: true,
            valueGetter: (params) => {
                const foreignKey = params.row.user;
                return foreignKey.lastName;
            },
            flex: 1
        },
        {
            field: 'checkDatime',
            headerName: 'Ngày lập đơn',
            width: 230,
            editable: true,
            flex: 1,
            renderCell: (params) => {
                return (
                    <p>{moment(params.value).format("YYYY-MM-DD, hh:mm:ss")}</p>
                )
            }
        },
        {
            field: 'description',
            headerName: 'Kiểm kê ngày',
            width: 230,
            editable: true,
            flex: 1,
            renderCell: (params) => {
                return (
                    <p>{moment(params.value).format("YYYY-MM-DD, hh:mm:ss")}</p>
                )
            }
        },
        {
            headerName: 'Chức năng',
            width: 100,

            renderCell: ({ row: { access, id } }) => {
                return (
                    <Button
                        onClick={handleOpenDialog.bind(null, id, access)}
                        sx={{
                            backgroundColor: colors.green[900],
                            color: colors.grey[100],
                            fontSize: '14px',
                            fontWeight: 'bold',
                            padding: '5px 10px',
                        }}
                    >
                        Chi tiết
                    </Button>
                );
            },
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
                    Kiểm kê
                </Typography>
                <Box>
                    <div className="row" style={{ marginBottom: "20px" }}>
                        <div className="col-lg-3">
                            <div className="form-group">
                                <label>
                                    <b>Thời gian tạo kiểm kê</b>
                                </label>
                                <input
                                    type="date"
                                    value={startDate}
                                    className="form-control"
                                    onChange={(e) => setStart(e.target.value)}
                                />
                            </div>
                        </div>
                        <div className="col-lg-3">
                            <div className="form-group" style={{ marginTop: "20px" }}>
                                <button
                                    onClick={handSearch}
                                    style={{
                                        backgroundColor: colors.green[900],
                                        fontWeight: 'bold',
                                        borderRadius: "5px",
                                        color: "white",
                                        fontSize: "12px",
                                        padding: "10px 20px",
                                    }}>
                                    Tạo kiểm kê 
                                </button>
                            </div>
                        </div>
                    </div>
                </Box>
            </Box>

            <Box sx={{ height: '60vh', width: '100%' }} display="flex" justifyContent="space-between">
                <DataGrid
                    rows={data}
                    columns={columns}
                    initialState={{
                        pagination: {
                            paginationModel: {
                                pageSize: 5,
                            },
                        },
                    }}
                    pageSizeOptions={[5]}
                    disableRowSelectionOnClick
                />
            </Box>
            <Box m={2}>
                <Link to="/MrSoai/ware" className="btn btn-danger">Thoát</Link>
            </Box>
            <Dialog open={openDialog} onClose={handleCloseDialog}>
                <DialogTitle textAlign={"center"}>Chi tiết xuất kho</DialogTitle>
                {detail === null ? (
                    <div>Đang load</div>
                ) : (
                    <DialogContent>
                        <div>
                            <p>Người kiểm kê: {detail.user.userName}</p>
                            <p>Ngày kiểm kê: {detail.checkDatime}</p>
                            <table style={{ borderCollapse: "collapse" }}>
                                <thead>
                                    <tr>
                                        <th style={{ border: "1px solid black", padding: "8px" }}>
                                            Nguyên liệu
                                        </th>
                                        <th style={{ border: "1px solid black", padding: "8px" }}>
                                            Số lượng
                                        </th>
                                    </tr>
                                </thead>

                                <tbody>
                                    {detail === null ? (
                                        <tr>
                                            <td colSpan="2">null</td>
                                        </tr>
                                    ) : (
                                        detail.goodsIssueDetails.map((detail) => (
                                            <tr key={detail.id}>
                                                <td
                                                    style={{
                                                        border: "1px solid black",
                                                        padding: "8px",
                                                        whiteSpace: "nowrap",
                                                    }}
                                                >
                                                    {detail.ingredients.ingredientName}
                                                </td>
                                                <td
                                                    style={{
                                                        border: "1px solid black",
                                                        padding: "8px",
                                                        whiteSpace: "nowrap",
                                                    }}
                                                >
                                                    {detail.quantity}
                                                </td>

                                            </tr>
                                        ))
                                    )}
                                </tbody>
                            </table>

                            <p>Ghi chú: {detail.description}</p>
                        </div>
                    </DialogContent>
                )}
                <DialogActions>
                    <Button onClick={handleCloseDialog}>Đóng</Button>
                </DialogActions>
            </Dialog>
        </Box>
    )
}