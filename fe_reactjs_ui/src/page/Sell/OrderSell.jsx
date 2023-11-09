import React, { useEffect, useState } from "react";
import {
  Box,
  Button,
  Dialog,
  DialogActions,
  DialogContent,
  DialogTitle,
  colors,
} from "@mui/material";
import { DataGrid } from "@mui/x-data-grid";
import axios from "axios";
import moment from "moment";
export default function OrderSell(searchOrder) {
  const signalR = require("@microsoft/signalr");
  const [order, setorder] = useState([]);
  const [openDialog, setOpenDialog] = useState(false);
  const [token, settoken] = useState(localStorage.getItem("token"));
  const [selectedOrder, setSelectedOrder] = useState(null);
  const [orderId, setOrderId] = useState(null);
  const [sizeId, setsizeId] = useState(null);
  const [toppingId, settoppingId] = useState(null);
  const [topping, settopping] = useState(null);
  const [title, setTitle] = useState("");
  const [body, setbody] = useState("");
  const [userId, setUserId] = useState(null);
  const [code, setcode] = useState(null);
  const [thong, setThong] = useState(null);
  const [initialOrder, setInitialOrder] = useState([]);
  const [show, setshow] = useState(true)
  const [ordershow, setorderShow] = useState([])
  let sta = false
  const formatOrderStatus = (params) => {
    const status = params.value;
    return statusMapping[status];
  };
  const statusMapping = {
    0: "Đang chờ xử lý",
    1: "Đã xác nhận",
    2: "Đang giao",
    3: "Đã hoàn thành",
  };
  const fetchOrder = () => {
    axios
      .get("https://localhost:7245/Admin/v1/api/order")
      .then((response) => {
        setorder(response.data);
        setdata(response.data);
      })
      .catch((error) => {
        console.log(error);
      });
  };
  const [data, setdata] = useState([]);
  useEffect(() => {
    let arr = [];
    order.map((item) => {
      arr.push(item);
    });
    if (searchOrder["searchOrder"] !== "") {
      setorder((ma) =>
        arr.filter((ma) => ma.code.includes(searchOrder["searchOrder"].trim()))
      );
    } else {
      setorder(data);
    }
  }, [order, searchOrder]);

  useEffect(() => {
    let connection = new signalR.HubConnectionBuilder()
      .withUrl("https://localhost:7245/Websocket")
      .withAutomaticReconnect([200, 3000])
      .build();

    connection.on("OrderMessage", (data) => {
      fetchOrder();
    });

    connection.start().catch((error) => console.log("Loi ket noi:", error));
    return () => {
      connection.stop();
    };
  }, [signalR.HubConnectionBuilder]);

  const handleAll = () => {
    setshow(true)
    axios
      .get("https://localhost:7245/Admin/v1/api/order")
      .then((response) => {
        setorder(response.data);
        setdata(response.data);
      })
      .catch((error) => {
        console.log(error);
      });
  }
  const handleDXL = (e) => {
    e.preventDefault();
    setshow(false)
    axios
      .get("https://localhost:7245/Admin/v1/api/order/DC")
      .then((response) => {
        setorderShow(response.data);
      })
      .catch((error) => {
        console.log(error);
      });
  }
  const handleDXN = (e) => {
    e.preventDefault();
    setshow(false)
    const filteredorder = order.filter(
      (item) =>
        item.orderStatus === 1
    );
    setorderShow(filteredorder);
  }
  const handleDG = (e) => {
    e.preventDefault();
    setshow(false)
    const filteredorder = order.filter(
      (item) =>
        item.orderStatus === 2
    );
    setorderShow(filteredorder);
  }
  const handleDHT = (e) => {
    e.preventDefault();
    setshow(false)
    const filteredorder = order.filter(
      (item) =>
        item.orderStatus === 3
    );
    setorderShow(filteredorder);
  }
  const handleCloseDialog = () => {
    setOpenDialog(false);
    axios
      .get("https://localhost:7245/Admin/v1/api/order")
      .then((response) => {
        setorder(response.data);
        setdata(response.data);
      })
      .catch((error) => {
        console.log(error);
      });
    if (selectedOrder !== thong) {
      const formData = new FormData();
      formData.append("title", title);
      formData.append("body", body);
      formData.append("userId", userId);
      fetch(
        "https://localhost:7245/Admin/v1/api/Notifications/send-notification-to-user/" +
        userId +
        "?title=" +
        title +
        "&body=" +
        body,
        {
          method: "POST",
          body: formData,
        }
      )
        .then((res) => { })
        .catch((err) => {
          console.log(err.message);
        });
      setThong(selectedOrder)
      console.log(state)
      console.log(thong)
    }
  };
  const handleOpenDialog = (id) => {
    setOpenDialog(true);
    axios
      .get("https://localhost:7245/Admin/v1/api/order/" + id + "/detail")
      .then(async (response) => {
        setSelectedOrder(await response.data);
        const user = selectedOrder.map((u) => u.userId);
        const codeorder = selectedOrder.map((u) => u.code);
        setThong(response.data.orderStatus);
        setUserId(user);
        setcode(codeorder);
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
  const column: GridColDef[] = [
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
        return <p>{moment(params.value).format("hh:mm:ss, YYYY-MM-DD")}</p>;
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
      field: "deliveryMethod",
      headerName: "Hình thức",
      editable: true,
      flex: 1,
    },
    {
      align: "right",
      width: 100,
      flex: 1,
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
  const [state, setState] = useState(null)
  const handleStatusChange = (orderCode, newStatus) => {
    setState(newStatus)
    try {
      const empdata = {
        id: orderId,
        orderStatus: newStatus,
      };
      fetch(
        `https://localhost:7245/Admin/v1/api/order/` + orderId + `/detail`,
        {
          method: "PUT",
          headers: {
            "Content-Type": "application/json",
          },
          body: JSON.stringify(empdata),
        }
      );
      //  update the UI with the new status value
      const orderIndex = order.findIndex((order) => order.id === orderId);
      if (orderIndex !== -1) {
        const updatedOrder = {
          ...order[orderIndex],
          orderStatus: newStatus,
        };
        const updatedOrders = [
          ...order.slice(0, orderIndex),
          updatedOrder,
          ...order.slice(orderIndex + 1),
        ];
        setorder(updatedOrders);
      }
      if (parseInt(newStatus, 10) === 1) {
        setTitle("Đã xác nhận");
        setbody(
          "Đơn hàng mã " +
          code +
          " của bạn đã được xác nhận vui lòng chờ trong giây lát"
        );
      } else if (parseInt(newStatus, 10) === 2) {
        setTitle("Đang giao");
        setbody("Đơn hàng mã " + code + " của bạn đang giao");
      } else if (parseInt(newStatus, 10) === 3) {
        setTitle("Đã hoàn thành");
        setbody(
          "Đơn hàng mã " +
          code +
          " của bạn đã hoàn thành, Mr Soai chúc bạn ăn uống ngon miệng"
        );
      }
    } catch (error) {
      console.error(error);
    }
  };

  return (
    <Box sx={{ height: "83vh", width: "100%" }}>
      <Box style={{ display: "flex" }} m="5px">
        <Button style={styles.button} onClick={handleAll}>Tất cả</Button>
        <Button style={styles.button} onClick={handleDXL}>Đang chờ xử lý</Button>
        <Button style={styles.button} onClick={handleDXN}>Đã xác nhận</Button>
        <Button style={styles.button} onClick={handleDG}>Đang giao</Button>
        <Button style={styles.button} onClick={handleDHT}>Đã hoàn thành</Button>
      </Box>
      {show ? (<DataGrid
        style={{ backgroundColor: "white" }}
        rows={order}
        columns={column}
        initialState={{
          pagination: {
            paginationModel: {
              pageSize: 10,
            },
          },
        }}
        pageSizeOptions={[10]}
        disableRowSelectionOnClick
      />) : (<DataGrid
        style={{ backgroundColor: "white" }}
        rows={ordershow}
        columns={column}
        initialState={{
          pagination: {
            paginationModel: {
              pageSize: 10,
            },
          },
        }}
        pageSizeOptions={[10]}
        disableRowSelectionOnClick
      />)}

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
                  Tình trạng:
                  <select
                    //value={sta ?(bien):(order.orderStatus) }
                    onChange={(event) => handleStatusChange(order.id, event.target.value)}
                  >
                    {Object.keys(statusMapping).map((status) => (
                      <option
                        key={status}
                        value={status}
                        disabled={status < order.orderStatus}
                      >
                        {statusMapping[status]}
                      </option>
                    ))}
                  </select>
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
  );
}
const styles = {
  button: {
    backgroundColor: colors.yellow[700],
    color: "white",
    border: "none",
    borderRadius: "5px",
    padding: "10px",
    fontSize: "10px",
    fontWeight: "bold",
    cursor: "pointer",
    marginRight: "10px",
  },
};