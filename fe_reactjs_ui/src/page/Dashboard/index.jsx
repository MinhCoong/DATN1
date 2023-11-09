import React, { useEffect, useState } from "react";
import { Box, Typography, useTheme } from "@mui/material";
import { tokens } from "../../theme";
//import DownloadOutlinedIcon from "@mui/icons-material/DownloadOutlined";
import {
  LineChart,
  Line,
  XAxis,
  YAxis,
  Tooltip,
  Legend,
  ResponsiveContainer,
  PieChart,
  Pie,
  Cell,
} from "recharts";
import axios from "axios";
import { BsFillCartFill, BsPeopleFill } from "react-icons/bs";
import { BiFoodMenu } from "react-icons/bi";
import moment from "moment";
const Dashboard = () => {
  const theme = useTheme();
  const colors = tokens(theme.palette.mode);
  const [revenue, setRevenues] = useState("");
  const [sales, setSales] = useState("");
  const [customer, setCustomer] = useState("");
  const [profit, setProfit] = useState("");
  const [optionsales, setOptionSales] = useState(0);
  const [OptionCustomer, setOptionCustomer] = useState(0);
  const [OptionRenevue, setRenevue] = useState(0);
  const [OptionProfit, setOptionProfit] = useState(0);
  const [order, setOrder] = useState([]);
  const countorder = order.length;
  const [product, setProduct] = useState([]);
  const [producttrue, setProducttrue] = useState([]);
  const countproduct = producttrue.length;
  const [insider, setInsider] = useState([]);
  const countinsider = insider.length;
  const [kh, setKh] = useState([]);
  const countKH = kh.length;
  const [token, settoken] = useState(localStorage.getItem("token"));
  const handleChangeSales = (e) => {
    const selectedIndex = e.target.selectedIndex; // Lấy chỉ mục của lựa chọn được chọn
    const selectedValue = e.target.options[selectedIndex].value; // Lấy giá trị của lựa chọn được chọn
    let value = null;
    if (selectedValue === "0") {
      value = 0;
    } else if (selectedValue === "1") {
      value = 1;
    } else if (selectedValue === "2") {
      value = 2;
    }
    setOptionSales(value);
  };
  const handleChangeRevenue = (e) => {
    const selectedIndex = e.target.selectedIndex; // Lấy chỉ mục của lựa chọn được chọn
    const selectedValue = e.target.options[selectedIndex].value; // Lấy giá trị của lựa chọn được chọn
    let value = null;
    if (selectedValue === "0") {
      value = 0;
    } else if (selectedValue === "1") {
      value = 1;
    } else if (selectedValue === "2") {
      value = 2;
    }
    setRenevue(value);
  };
  const handleChangeCustomer = (e) => {
    const selectedIndex = e.target.selectedIndex; // Lấy chỉ mục của lựa chọn được chọn
    const selectedValue = e.target.options[selectedIndex].value; // Lấy giá trị của lựa chọn được chọn
    let value = null;
    if (selectedValue === "0") {
      value = 0;
    } else if (selectedValue === "1") {
      value = 1;
    } else if (selectedValue === "2") {
      value = 2;
    }
    setOptionCustomer(value);
  };
  const handleChangeSetProfit = (e) => {
    const selectedIndex = e.target.selectedIndex; // Lấy chỉ mục của lựa chọn được chọn
    const selectedValue = e.target.options[selectedIndex].value; // Lấy giá trị của lựa chọn được chọn
    let value = null;
    if (selectedValue === "0") {
      value = 0;
    } else if (selectedValue === "1") {
      value = 1;
    } else if (selectedValue === "2") {
      value = 2;
    }
    setOptionProfit(value);
  };
  useEffect(() => {
    axios
      .get(
        "https://localhost:7245/Admin/v1/api/Statistics/GetSales?i=" +
          optionsales
      )
      .then(async (response) => {
        setSales(await response.data);
      })
      .catch((error) => {
        console.log(error);
      });
  }, [optionsales]);
  useEffect(() => {
    axios
      .get(
        "https://localhost:7245/Admin/v1/api/Statistics/NewCustommer?i=" +
          OptionCustomer
      )
      .then(async (response) => {
        setCustomer(await response.data);
      })
      .catch((error) => {
        console.log(error);
      });
  }, [OptionCustomer]);
  useEffect(() => {
    axios
      .get(
        "https://localhost:7245/Admin/v1/api/Statistics/GetRevenue?i=" +
          OptionRenevue
      )
      .then(async (response) => {
        setRevenues(await response.data);
      })
      .catch((error) => {
        console.log(error);
      });
  }, [OptionRenevue]);
  useEffect(() => {
    axios
      .get(
        "https://localhost:7245/Admin/v1/api/Statistics/GetProfit?i=" +
        OptionProfit
      )
      .then(async (response) => {
        setProfit(await response.data);
      })
      .catch((error) => {
        console.log(error);
      });
  }, [OptionProfit]);
  useEffect(() => {
    axios
      .get("https://localhost:7245/Admin/v1/api/order/static")
      .then((response) => {
        setOrder(response.data);
      })
      .catch((error) => {
        console.log(error);
      });
    console.log(data);
  }, []);
  useEffect(() => {
    axios
      .get("https://localhost:7245/Admin/v1/api/product", {
        headers: { Authorization: `Bearer ${token}` },
      })
      .then((response) => {
        setProduct(response.data);
      })
      .catch((error) => {
        console.log(error);
      });
  }, []);
  useEffect(() => {
    let arr = [];
    product.map((item) => {
      if (item.status) {
        arr.push(item);
      }
    });
    setProducttrue(arr);
  }, [product]);
  useEffect(() => {
    axios
      .get("https://localhost:7245/Admin/v1/api/Users/Insider", {
        headers: { Authorization: `Bearer ${token}` },
      })
      .then((response) => {
        setInsider(response.data);
      })
      .catch((error) => {
        console.log(error);
      });
  }, []);
  useEffect(() => {
    axios
      .get("https://localhost:7245/Admin/v1/api/Users/Customer", {
        headers: { Authorization: `Bearer ${token}` },
      })
      .then((response) => {
        setKh(response.data);
      })
      .catch((error) => {
        console.log(error);
      });
  }, []);
  const statusCounts = {};
  order.forEach((item) => {
    const status = item.orderStatus;
    if (!statusCounts[status]) {
      statusCounts[status] = 1;
    } else {
      statusCounts[status]++;
    }
  });

  const data = Object.keys(statusCounts).map((status) => ({
    orderStatus: parseInt(status),
    value: statusCounts[status],
  }));
  const orderStatusLabels = {
    0: "Đang chờ xử lý",
    1: "Đã xác nhận",
    2: "Đang giao",
    3: "Đã hoàn thành",
  };
  const statusFormatter = (value) => orderStatusLabels[value];
  const COLORS = ["#0088FE", "#00C49F", "#FFBB28", "#FF6384"];
  const formatTime = (time) => {
    return moment(time).format("YYYY-MM-DD, hh:mm:ss");
  };
  return (
    <Box m="10px" p="3px" overflow={"auto"} sx={{ height: "90vh" }}>
      {/* Header */}
      <Box display="flex" justifyContent="space-between" alignItems="center">
        <Box mb="30px">
          <Typography
            variant="h2"
            color={colors.grey[100]}
            fontWeight="bold"
            sx={{ m: " 0 0 5px 0" }}
          >
            Trang Chủ
          </Typography>
          <Typography variant="h5" color={colors.greenAccent[400]}>
            Chào mừng bạn đến với trang chủ
          </Typography>
        </Box>
      </Box>
      {/* Body */}
      <Box
        display="grid"
        gridTemplateColumns="repeat(12, 1fr)"
        gridAutoRows="140px"
        gap="20px"
      >
        {/* Row1 */}
        {/* Column1 */}
        <Box
          backgroundColor={colors.primary[400]}
          gridColumn="span 3"
          display="flex"
          alignItems="center"
          justifyContent="center"
          borderRadius="10px"
        >
          <Box sx={{ display: "flex", alignItems: "left" }}>
            <BsFillCartFill fontSize={"60px"} color={colors.greenAccent[600]} />
            <Box>
              <Typography
                variant="h3"
                color={colors.grey[100]}
                fontWeight="bold"
                sx={{ m: " 0 0 5px 0" }}
              >
                Tổng số đơn hàng
              </Typography>
              <Typography variant="h3" fontWeight="bold">
                {countorder}
              </Typography>
            </Box>
          </Box>
        </Box>
        {/* Column2 */}
        <Box
          backgroundColor={colors.primary[400]}
          gridColumn="span 3"
          display="flex"
          alignItems="center"
          justifyContent="center"
          borderRadius="10px"
        >
          <Box sx={{ display: "flex", alignItems: "left" }}>
            <BiFoodMenu fontSize={"60px"} color={colors.greenAccent[600]} />
            <Box>
              <Typography
                variant="h3"
                color={colors.grey[100]}
                fontWeight="bold"
                sx={{ m: " 0 0 5px 0" }}
              >
                Sản phẩm
              </Typography>
              <Typography variant="h3" fontWeight="bold">
                {countproduct}
              </Typography>
            </Box>
          </Box>
        </Box>
        {/* Column3 */}
        <Box
          backgroundColor={colors.primary[400]}
          gridColumn="span 3"
          display="flex"
          alignItems="center"
          justifyContent="center"
          borderRadius="10px"
        >
          <Box sx={{ display: "flex", alignItems: "left" }}>
            <BsPeopleFill fontSize={"60px"} color={colors.greenAccent[600]} />
            <Box>
              <Typography
                variant="h3"
                color={colors.grey[100]}
                fontWeight="bold"
                sx={{ m: " 0 0 5px 0" }}
              >
                Nhân viên
              </Typography>
              <Typography variant="h3" fontWeight="bold">
                {countinsider}
              </Typography>
            </Box>
          </Box>
        </Box>
        {/* Column4 */}
        <Box
          backgroundColor={colors.primary[400]}
          gridColumn="span 3"
          display="flex"
          alignItems="center"
          justifyContent="center"
          borderRadius="10px"
        >
          <Box sx={{ display: "flex", alignItems: "left" }}>
            <BsPeopleFill fontSize={"60px"} color={colors.greenAccent[600]} />
            <Box>
              <Typography
                variant="h3"
                color={colors.grey[100]}
                fontWeight="bold"
                sx={{ m: " 0 0 5px 0" }}
              >
                Khách hàng
              </Typography>
              <Typography variant="h3" fontWeight="bold">
                {countKH}
              </Typography>
            </Box>
          </Box>
        </Box>
        {/* Row2 */}
        {/* Column1 */}
        <Box
          gridColumn="span 8"
          gridRow="span 2"
          backgroundColor={colors.primary[400]}
          borderRadius="10px"
          position="relative"
        >
          <Box marginBottom="20px">
            <Box display={"flex"} justifyContent={"space-between"}>
              <label style={{ margin: "2px" }}>Biểu đồ doanh thu</label>
              <select
                name="cars"
                id="cars"
                style={{ borderRadius: "10px", margin: "2px" }}
                defaultValue="0"
                onChange={handleChangeRevenue}
              >
                <option value="0">Ngày</option>
                <option value="1">Tháng</option>
                <option value="2">Năm</option>
              </select>
            </Box>
            <ResponsiveContainer width="100%" height={280}>
              <LineChart
                data={revenue}
                margin={{ top: 5, right: 30, bottom: 5 }}
              >
                <XAxis
                  dataKey="id"
                  tick={{ fill: colors.greenAccent[600] }}
                  //tickFormatter={formatTime}
                />
                <YAxis
                  tick={{
                    fill: colors.greenAccent[600],
                    fontSize: 12,
                    fontWeight: "bold",
                    interval: 20,
                    formatter: (value) => `${value}%`,
                  }}
                />
                <Tooltip />
               
                <Line
                  type="monotone"
                  dataKey="total"
                  stroke="#8884d8"
                  activeDot={{ r: 8 }}
                />
              </LineChart>
            </ResponsiveContainer>
          </Box>
          <Box
            marginBottom="20px"
            width={"150%"}
            backgroundColor={colors.primary[400]}
          >
            <Box display={"flex"} justifyContent={"space-between"}>
              <label style={{ margin: "2px" }}>Biểu đồ doanh số</label>
              <select
                name="cars"
                id="cars"
                style={{ borderRadius: "10px", margin: "2px" }}
                defaultValue="0"
                onChange={handleChangeSales}
              >
                <option value="0">Ngày</option>
                <option value="1">Tháng</option>
                <option value="2">Năm</option>
              </select>
            </Box>
            <ResponsiveContainer width="100%" height={300}>
              <LineChart data={sales} margin={{ top: 5, right: 30, bottom: 5 }}>
                <XAxis
                  dataKey="id"
                  tick={{ fill: colors.greenAccent[600] }}
                  //tickFormatter={formatTime}
                />
                <YAxis
                  tick={{
                    fill: colors.greenAccent[600],
                    fontSize: 12,
                    fontWeight: "bold",
                    interval: 20,
                    formatter: (value) => `${value}%`,
                  }}
                />
                <Tooltip />

                <Line
                  type="monotone"
                  dataKey="total"
                  stroke="#8884d8"
                  activeDot={{ r: 8 }}
                />
                {/* <Line type="monotone" dataKey="uv" stroke="#82ca9d" />
                                <Line type="monotone" dataKey="amt" stroke="#82ca9d" /> */}
              </LineChart>
            </ResponsiveContainer>
          </Box>
          <Box
          marginBottom="20px"
            width={"150%"}
            backgroundColor={colors.primary[400]}
            borderRadius="10px"
          >
            <Box display={"flex"} justifyContent={"space-between"}>
              <label style={{ margin: "2px" }}>Biểu đồ khách hàng mới</label>
              <select
                name="cars"
                id="cars"
                style={{ borderRadius: "10px", margin: "2px" }}
                defaultValue="0"
                onChange={handleChangeCustomer}
              >
                <option value="0">Ngày</option>
                <option value="1">Tháng</option>
                <option value="2">Năm</option>
              </select>
            </Box>
            <ResponsiveContainer width="100%" height={300}>
              <LineChart
                data={customer}
                margin={{ top: 5, right: 30, bottom: 5 }}
              >
                <XAxis
                  dataKey="total"
                  tick={{ fill: colors.greenAccent[600] }}
                  //tickFormatter={formatTime}
                />
                <YAxis
                  tick={{
                    fill: colors.greenAccent[600],
                    fontSize: 12,
                    fontWeight: "bold",
                    interval: 20,
                    
                  }}
                />
                <Tooltip />
               
                <Line
                  type="monotone"
                  dataKey="listCustomer"
                  stroke="#8884d8"
                  activeDot={{ r: 8 }}
                />
               
              </LineChart>
            </ResponsiveContainer>
          </Box>
          <Box
            width={"150%"}
            backgroundColor={colors.primary[400]}
            borderRadius="10px"
          >
            <Box display={"flex"} justifyContent={"space-between"}>
              <label style={{ margin: "2px" }}>Biểu đồ lợi nhuận </label>
              <select
                name="cars"
                id="cars"
                style={{ borderRadius: "10px", margin: "2px" }}
                defaultValue="0"
                onChange={handleChangeSetProfit}
              >
                <option value="0">Ngày</option>
                <option value="1">Tháng</option>
                <option value="2">Năm</option>
              </select>
            </Box>
            <ResponsiveContainer width="100%" height={300}>
              <LineChart
                data={profit}
                margin={{ top: 5, right: 30, bottom: 5 }}
              >
                <XAxis
                  dataKey="id"
                  tick={{ fill: colors.greenAccent[600] }}
                  //tickFormatter={formatTime}
                />
                <YAxis
                  tick={{
                    fill: colors.greenAccent[600],
                    fontSize: 12,
                    fontWeight: "bold",
                    interval: 20,
                    formatter: (value) => `${value}%`,
                  }}
                />
                <Tooltip />
              
                <Line
                  type="monotone"
                  dataKey="total"
                  stroke="#8884d8"
                  activeDot={{ r: 8 }}
                />
               
              </LineChart>
            </ResponsiveContainer>
          </Box>
        </Box>
        {/* Column2 */}
        <Box
          borderRadius="10px"
          gridColumn="span 4"
          gridRow="span 2"
          backgroundColor={colors.primary[400]}
          justifyContent="center"
        >
          <label style={{ marginLeft: "100px" }}>
            {" "}
            Thống kê trạng thái đơn hàng
          </label>
          <PieChart
            width={400}
            height={350}
            style={{ top: "-20%", right: "0%" }}
          >
            <Pie
              data={data}
              dataKey="value"
              cx={200}
              cy={200}
              innerRadius={60}
              outerRadius={80}
              fill="#8884d8"
              label={({ orderStatus,value }) => `${value}: ${statusFormatter(orderStatus)}`}
            >
              {order.map((entry, index) => (
                <Cell
                  key={`cell-${index}`}
                  fill={COLORS[index % COLORS.length]}
                />
              ))}
              <Legend payload={data.map((entry, index) => ({ value: entry.orderStatus }))} />
              <Tooltip
                formatter={(value, orderStatus, entry) => [
                  statusFormatter(entry.payload.orderStatus),
                ]}
                labelFormatter={(label) => `Custom ${label}`}
                itemStyle={{ color: "red" }}
                labelStyle={{ fontWeight: "bold" }}
                contentStyle={{ backgroundColor: "white" }}
                cursor={false}
              />
            </Pie>
          </PieChart>
        </Box>
        
      </Box>
    </Box>
  );
};
export default Dashboard;
