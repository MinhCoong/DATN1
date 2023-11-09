import { DataGrid, GridColDef } from "@mui/x-data-grid";
import { tokens } from "../../theme";
import { Typography } from "@mui/material";
import React, { useEffect, useState } from "react";
import {
  Box,
  Button,
  Dialog,
  DialogActions,
  DialogContent,
  DialogTitle,
  colors,
  useTheme,
} from "@mui/material";
import axios from "axios";
import moment from "moment";

export default function Invoice() {
  const theme = useTheme();
  const color = tokens(theme.palette.mode);
  const [order, setorder] = useState([]);
  const [openDialog, setOpenDialog] = useState(false);
  const [token, settoken] = useState(localStorage.getItem("token"));
  const formatOrderStatus = (params) => {
    const status = params.value;
    return statusMapping[status];
  };
  const statusMapping = {
    0: "Đang chờ xử lý",
    1: "Đã xác nhận",
    2: "Đã xử lý",
    3: "Đã hoàn thành",
  };
  const [selectedOrder, setSelectedOrder] = useState(null);
  const [orderId, setOrderId] = useState(null);
  const [sizeId, setsizeId] = useState(null);
  const [toppingId, settoppingId] = useState(null);
  const [topping, settopping] = useState(null);
  const [startDate, setStart] = useState('')
  const [endDate, setEnd] = useState('')
  const handleCloseDialog = () => {
    setOpenDialog(false);
  };
  useEffect(() => {
    axios
      .get("https://localhost:7245/Admin/v1/api/order")
      .then((response) => {
        setorder(response.data);
      })
      .catch((error) => {
        console.log(error);
      });
  }, []);
  const handleOpenDialog = (id) => {
    setOpenDialog(true);
    axios
      .get("https://localhost:7245/Admin/v1/api/order/" + id + "/detail")
      .then(async (response) => {
        setSelectedOrder(await response.data);
      })
      .catch((error) => {
        console.log(error);
      });
    setOrderId(id);
    axios
      .get("https://localhost:7245/Admin/v1/api/orderdetail")
      .then(async (response) => {
        const OrderDetail = await response.data;
        const filterorder = OrderDetail.filter((order) => order.orderId === id);
        const toppingsIds = filterorder.map((orderDetail) =>
          orderDetail.orderdetailToppingList.map(
            (topping) => topping.toppingsId
          )
        );
        setsizeId(filterorder);
        settoppingId(toppingsIds);
      })
      .catch((error) => {
        console.log(error);
      });
  };
  axios
    .get("https://localhost:7245/Admin/v1/api/topping", {
      headers: { Authorization: `Bearer ${token}` },
    })
    .then(async (response) => {
      const OrderTopping = await response.data;
      const flatToppingId = toppingId.flat();
      const filtertopping = OrderTopping.filter((topping) =>
        flatToppingId.includes(topping.id)
      );
      settopping(filtertopping);
    })
    .catch((error) => {
      console.log(error);
    });
  const columns: GridColDef[] = [
    {
      field: "code",
      headerName: "Mã đơn hàng",
      editable: true,
      flex: 1,
    },
    {
      field: "orderDate",
      headerName: "Thời gian đặt",
      editable: true,
      flex: 1,
      renderCell: (params) => {
        return <p>{moment(params.value).format("YYYY-MM-DD, hh:mm:ss")}</p>;
      },
    },
    {
      field: "orderStatus",
      headerName: "Tình trạng",
      editable: true,
      flex: 1,
      valueFormatter: formatOrderStatus,
    },
    {
      field: "total",
      headerName: "Tổng tiền",
      editable: false,
      flex: 1,
      align: "left",
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
      headerName: "Chức năng",
      width: 100,

      renderCell: ({ row: { access, id } }) => {
        return (
          <Button
            onClick={handleOpenDialog.bind(null, id)}
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
  const handSearch = () => {
    axios
      .get("https://localhost:7245/Admin/v1/api/AdminOrders/Statistics?dateStart="+startDate+"&dateEnd="+endDate)
      .then((response) => {
        setorder(response.data);
      })
      .catch((error) => {
        console.log(error);
      });
  }
  return (
    <Box m="20px">
      <Box mb="10px">
        <Typography
          variant="h2"
          color={color.grey[100]}
          fontWeight="bold"
          sx={{ m: " 0 0 5px 0" }}
        >
          Hóa Đơn
        </Typography>
      </Box>
      <div className="row" style={{ marginBottom: "20px" }}>
        <div className="col-lg-3">
          <div className="form-group">
            <label>
              <b>Từ ngày</b>
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
          <div className="form-group">
            <label>
              <b>Đến ngày</b>
            </label>
            <input
              type="date"
              value={endDate}
              className="form-control"
              onChange={(e) => setEnd(e.target.value)}
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
              Tìm
            </button>
          </div>
        </div>
      </div>
      <Box
        sx={{ height: "65vh", width: "100%" }}
        display="flex"
        justifyContent="space-between"
      >
        <DataGrid
          rows={order}
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
        <Dialog open={openDialog} onClose={handleCloseDialog}>
        <DialogTitle textAlign={"center"}>Chi tiết hóa đơn</DialogTitle>
        {selectedOrder === null ? (
          <div>Đợi tý đang chạy</div>
        ) : (
          <DialogContent>
            {selectedOrder.map((order) => (
              <div>
                <div className="row">
                  <p>Mã đơn hàng: {order.code}</p>
                  <p>Khách hàng: {order.consigneeName}</p>
                </div>
                {/* {setUserId(order.userId)} */}
                <p>
                    Tình trạng:{" "}
                    {formatOrderStatus({ value: order.orderStatus })}
                  </p>
                <p>Ngày đặt hàng: {moment(order.orderDate).format("YYYY-MM-DD, hh:mm:ss")}</p>
                <p>Số điện thoại: {order.consigneePhoneNumber}</p>
                <p>Nơi đặt: {order.deliveryMethod}</p>
                <table style={{ borderCollapse: "collapse" }}>
                  <thead>
                    <tr>
                      <th style={{ border: "1px solid black", padding: "8px" }}>
                        Sản phẩm
                      </th>
                      <th style={{ border: "1px solid black", padding: "8px" }}>
                        Size
                      </th>
                      <th style={{ border: "1px solid black", padding: "8px" }}>
                        Đơn giá
                      </th>
                      <th style={{ border: "1px solid black", padding: "8px" }}>
                        SL
                      </th>
                      <th style={{ border: "1px solid black", padding: "8px" }}>
                        Topping
                      </th>
                      <th style={{ border: "1px solid black", padding: "8px" }}>
                        Thành tiền
                      </th>
                    </tr>
                  </thead>
                  <tbody>
                    {order.orderDetails.map((orderDetail) => (
                      <tr key={orderDetail.product.productId}>
                        {/* {setbody('Đơn của bạn'+orderDetail.product.productName)} */}
                        <td
                          style={{
                            border: "1px solid black",
                            padding: "8px",
                            whiteSpace: "nowrap",
                          }}
                        >
                          {orderDetail.product.productName}
                        </td>
                        <td
                          style={{ border: "1px solid black", padding: "8px" }}
                        >
                          {orderDetail.size.sizeName}
                        </td>
                        <td
                          style={{ border: "1px solid black", padding: "8px" }}
                        >
                          {new Intl.NumberFormat("vi-VN", {
                            style: "currency",
                            currency: "VND",
                          }).format(orderDetail.price)}
                        </td>
                        <td
                          style={{ border: "1px solid black", padding: "8px" }}
                        >
                          {orderDetail.quantity}
                        </td>
                        <td
                          style={{
                            border: "1px solid black",
                            padding: "8px",
                            whiteSpace: "nowrap",
                          }}
                        >
                          {topping === null ? (
                            <div>null</div>
                          ) : (
                            <>
                              {topping.map((toppingItem, index) => {
                                const matchedTopping =
                                  orderDetail.orderdetailToppingList.find(
                                    (element) =>
                                      element.toppingsId === toppingItem.id
                                  );
                                if (matchedTopping) {
                                  return (
                                    <div key={toppingItem.id}>
                                      {toppingItem.toppingName}
                                    </div>
                                  );
                                }
                                return null;
                              })}
                            </>
                          )}
                        </td>

                        <td
                          style={{ border: "1px solid black", padding: "8px" }}
                        >
                          {new Intl.NumberFormat("vi-VN", {
                            style: "currency",
                            currency: "VND",
                          }).format(orderDetail.subtotal)}
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
                <p>Tổng tiền: {new Intl.NumberFormat("vi-VN", {
                  style: "currency",
                  currency: "VND",
                }).format(order.total)}</p>
                {order.coupons.id > 1 ? (
                  <>{
                    order.coupons.discount >= 1000 ? (
                      <p>
                        Mã khuyến mãi: {order.coupons.code} :{" "}
                        {order.coupons.discount}đ
                      </p>
                    ) : (
                      <p>
                        Mã khuyến mãi: {order.coupons.code} :{" "}
                        {order.coupons.discount}%
                      </p>
                    )
                  }</>) : (<p>
                    Mã khuyến mãi:
                  </p>)}

              </div>
            ))}
          </DialogContent>
        )}

        <DialogActions>
          <Button onClick={handleCloseDialog}>Xong</Button>

        </DialogActions>
      </Dialog>
      </Box>
    </Box>
  );
}
