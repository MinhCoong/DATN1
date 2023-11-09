import { useTheme } from "@emotion/react";
import {
  Box,
  Button,
  Typography,
  colors,
  Dialog,
  DialogActions,
  DialogContent,
  DialogTitle,
} from "@mui/material";
import React from "react";
import { tokens } from "../../theme";
import { DataGrid } from "@mui/x-data-grid";
import { Link } from "react-router-dom";
import { useState } from "react";
import { useEffect } from "react";
import axios from "axios";
import moment from "moment";
export default function OrderWare() {
  const theme = useTheme();
  const color = tokens(theme.palette.mode);
  const [openDialog, setOpenDialog] = useState(false);
  const [user, setUserId] = useState(null);
  const handleCloseDialog = () => {
    setOpenDialog(false);
  };
  const handleOpenDialog = async (id) => {
    setOpenDialog(true);
    axios
      .get("https://localhost:7245/Admin/v1/api/InventoryReceipts/" + id)
      .then(async (response) => {
        setUserId(response.data);
      })
      .catch((error) => {
        console.log(error);
      });
    console.log(user);
   
  };
  const [data, setData] = useState("");
  useEffect(() => {
    axios
      .get("https://localhost:7245/Admin/v1/api/InventoryReceipts")
      .then((response) => {
        setData(response.data);
      })
      .catch((error) => {
        console.log(error);
      });
  }, []);
  const columns: GridColDef[] = [
    {
      field: "user",
      headerName: "Họ",
      width: 150,
      editable: true,
      valueGetter: (params) => {
        const foreignKey = params.row.user;
        return foreignKey.firstName;
      },
      flex: 1,
    },
    {
      field: "userId",
      headerName: "Tên",
      width: 250,
      editable: true,
      valueGetter: (params) => {
        const foreignKey = params.row.user;
        return foreignKey.lastName;
      },
      flex: 1,
    },
    {
      field: "receiptDate",
      headerName: "Ngày lập đơn",
      width: 230,
      editable: true,
      flex: 1,
      renderCell: (params) => {
        return <p>{moment(params.value).format("YYYY-MM-DD, hh:mm:ss")}</p>;
      },
    },
    {
      headerName: "Chức năng",
      width: 100,

      renderCell: ({ row: { access, id } }) => {
        return (
          <Button
            onClick={handleOpenDialog.bind(null, id, access)}
            sx={{
              backgroundColor: colors.green[900],
              color: colors.grey[100],
              fontSize: "14px",
              fontWeight: "bold",
              padding: "5px 10px",
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
      <Box mb="30px">
        <Typography
          variant="h2"
          color={color.grey[100]}
          fontWeight="bold"
          sx={{ m: " 0 0 5px 0" }}
        >
          Hóa đơn kho
        </Typography>
      </Box>

      <Box
        sx={{ height: "70vh", width: "100%" }}
        display="flex"
        justifyContent="space-between"
      >
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
        <Link to="/MrSoai/ware" className="btn btn-danger">
          Thoát
        </Link>
      </Box>
      <Dialog open={openDialog} onClose={handleCloseDialog}>
        <DialogTitle textAlign={"center"}>Chi tiết hóa đơn nhập</DialogTitle>
        {user === null ? (
          <div>Đang load</div>
        ) : (
          <DialogContent>
            <div>
              <p>Người tạo hóa đơn: {user.user.userName}</p>
              <p>Ngày đặt hàng: {moment(user.receiptDate).format("YYYY-MM-DD, hh:mm:ss")}</p>
              <table style={{ borderCollapse: "collapse" }}>
                <thead>
                  <tr>
                    <th style={{ border: "1px solid black", padding: "8px" }}>
                      Nguyên liệu
                    </th>
                    <th style={{ border: "1px solid black", padding: "8px" }}>
                      Số lượng
                    </th>
                    <th style={{ border: "1px solid black", padding: "8px" }}>
                     Gía mua
                    </th>
                    <th style={{ border: "1px solid black", padding: "8px" }}>
                     Đơn vị
                    </th>
                    <th style={{ border: "1px solid black", padding: "8px" }}>
                     Thành tiền
                    </th>
                  </tr>
                </thead>

                <tbody>
                  {user === null ? (
                    <tr>
                      <td colSpan="2">null</td>
                    </tr>
                  ) : (
                    user.inventoryReceiptDetails.map((detail) => (
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
                        <td
                            style={{
                            border: "1px solid black",
                            padding: "8px",
                            whiteSpace: "nowrap",
                          }}
                        >
                          {new Intl.NumberFormat("vi-VN", {
              style: "currency",
              currency: "VND",
            }).format(detail.purchasePrice)}
                        </td>
                        <td
                            style={{
                            border: "1px solid black",
                            padding: "8px",
                            whiteSpace: "nowrap",
                          }}
                        >
                           {detail.ingredients.unit}
                        </td>
                        <td
                            style={{
                            border: "1px solid black",
                            padding: "8px",
                            whiteSpace: "nowrap",
                          }}
                        >
                           {}{new Intl.NumberFormat("vi-VN", {
              style: "currency",
              currency: "VND",
            }).format(detail.subtotal)}
                        </td>
                      </tr>
                    ))
                  )}
                </tbody>
              </table>
              <p>Tổng tiền: {}{new Intl.NumberFormat("vi-VN", {
              style: "currency",
              currency: "VND",
            }).format(user.totalValue)}</p>
              <p>Ghi chú: {user.description}</p>
            </div>
          </DialogContent>
        )}
        <DialogActions>
          <Button onClick={handleCloseDialog}>Đóng</Button>
        </DialogActions>
      </Dialog>
    </Box>
  );
}
