import React, { useEffect } from "react";
import {
  Box,
  useTheme,
  IconButton,
  Typography,
  InputBase,
  Grid,
  Card,
  CardContent,
  Button,
  ButtonGroup,
} from "@mui/material";
import { tokens } from "../../theme";
import Right from "./Right";
import { Link, useNavigate } from "react-router-dom";
import { BiLogOut } from "react-icons/bi";
import { AiFillAlert, AiFillLayout } from "react-icons/ai";
import { FaWineGlass } from "react-icons/fa";
import { MdPlaylistAddCircle } from "react-icons/md";
import { TiThSmall } from "react-icons/ti";
import SearchIcon from "@mui/icons-material/Search";
import { useState } from "react";
import axios from "axios";
import "./home.css";
import OrderSell from "./OrderSell";
function Home() {
  const theme = useTheme();
  const color = tokens(theme.palette.mode);
  const navigate = useNavigate();
  const [products, setProducts] = useState([]);
  const [topping, setTopping] = useState([]);
  const [data, setdata] = useState([]);
  const [selectedProduct, setSelectedProduct] = useState(null);
  const [sizes, setsize] = useState(1);
  const [showOrder, setShowOrder] = useState(false);
  const [token, settoken] = useState(localStorage.getItem("token"));
  const [searchQuery, setSearchQuery] = useState("");
  const sizeIdMap = {
    M: 1,
    L: 2,
  };
  const handleSizeChange = (productId, size) => {
    const sizeId = sizeIdMap[size];
    const updatedProducts = products.map((product) => {
      if (product.id === productId) {
        return {
          ...product,
          selectedSize: size,
          selectedSizeId: sizeId,
        };
      }
      return product;
    });
    setsize(sizeId);
    setProducts(updatedProducts);
    console.log(sizes);
  };
  const handleLogout = async (e) => {
    e.preventDefault();
    fetch("https://localhost:7245/v1/api/Authenticate/Logout", {
      method: "POST",
    })
      .then((res) => {
        localStorage.clear();
        navigate("/");
      })
      .catch((err) => {
        console.log(err.message);
      });
  };
  const handleall = async (e) => {
    e.preventDefault();
    const filteredProducts = products.filter((item) => item.status);
    setdata(filteredProducts);
    setShowOrder(true);
  };
  const handlefood = async (e) => {
    e.preventDefault();
    const filteredProducts = products.filter(
      (item) =>
        item.categoryId === 11 ||
        item.categoryId === 1 ||
        item.categoryId === 10
    );
    setdata(filteredProducts);
    setShowOrder(true);
  };
  const handledrink = async (e) => {
    e.preventDefault();
    const filteredProducts = products.filter(
      (item) =>
        item.categoryId === 9 ||
        item.categoryId === 2 ||
        item.categoryId === 3 ||
        item.categoryId === 4 ||
        item.categoryId === 5 ||
        item.categoryId === 6 ||
        item.categoryId === 7
    );
    setdata(filteredProducts);
    setShowOrder(true);
  };
  const handleorder = async (e) => {
    e.preventDefault();
    setShowOrder(false);
    setSearchQuery("");
  };
  const handleSearch = (e) => {
    setSearchQuery(e.target.value);
  };
  useEffect(() => {
    axios
      .get("https://localhost:7245/Admin/v1/api/product", {
        headers: { Authorization: `Bearer ${token}` },
      })
      .then(async (response) => {
        const initialProducts = await response.data.map((product) => ({
          ...product,
          selectedSize: "M",
        }));
        setProducts(initialProducts);
      })
      .catch((error) => {
        console.log(error);
      });
  }, []);
  useEffect(() => {
    axios
      .get("https://localhost:7245/Admin/v1/api/topping", {
        headers: { Authorization: `Bearer ${token}` },
      })
      .then((response) => {
        setTopping(response.data);
      })
      .catch((error) => {
        console.log(error);
      });
  }, []);
  useEffect(() => {
    let arr = [];
    products.map((item) => {
      if (item.status) {
        arr.push(item);
      }
    });
    setdata(
      arr.filter((product) =>
        product.productName.toLowerCase().includes(searchQuery.toLowerCase())
      )
    );
  }, [products, searchQuery]);

  const [ProductSize, setProductSize] = useState({
    productId: null,
    sizeId: null,
  });
  const handleadd = async (e, product, size) => {
    e.preventDefault();

    if (
      product.categoryId === 9 ||
      product.categoryId === 10 ||
      product.categoryId === 11
    ) {
      setProductSize({
        productId: product.id,
        sizeId: 1,
      });
    } else {
      setProductSize({
        productId: product.id,
        sizeId: sizes,
      });
    }
  };
  return (
    <div>
      {/* Thanh topbar */}
      <Box
        display="flex"
        justifyContent="space-between"
        p={1}
        backgroundColor={color.yellow[400]}
      >
        <Box display="flex">
          <IconButton onClick={handleall}>
            <TiThSmall />
            <Typography>Tất cả</Typography>
          </IconButton>
          <IconButton onClick={handlefood}>
            <AiFillAlert />
            <Typography>Đồ ăn</Typography>
          </IconButton>
          <IconButton onClick={handledrink}>
            <FaWineGlass />
            <Typography>Đồ uống</Typography>
          </IconButton>
          <IconButton onClick={handleorder}>
            <MdPlaylistAddCircle />
            <Typography>Đơn hàng</Typography>
          </IconButton>
        </Box>
        <Box
          display="flex"
          backgroundColor={color.primary[400]}
          borderRadius="3px"
          width="500px"
        >
          <InputBase
            sx={{ ml: 2, flex: 1 }}
            placeholder="Nhập tên mặt hàng"
            onChange={handleSearch}
            value={searchQuery}
          />
          <IconButton type="button" sx={{ p: "0 0 0 10px" }}>
            <SearchIcon />
          </IconButton>
        </Box>
        <Box display="flex">
          <Link to="/MrSoai/">
            <IconButton>
              <AiFillLayout />
            </IconButton>
          </Link>
          <IconButton onClick={handleLogout}>
            <BiLogOut />
          </IconButton>
        </Box>
      </Box>

      {showOrder ? (
        // Trang bán hàng
        <Box
          m="10px"
          display="grid"
          gridTemplateColumns="repeat(2, 1fr)"
          gridAutoRows="600px"
          gap="10px"
          backgroundColor={color.primary[400]}
        >
          <Box gridColumn="span 1" sx={{ height: "91vh" }} backgroundColor={color.primary[400]}>
            <div className="product-page-container">
              <div className="product-grid-container">
                <Grid container spacing={3}>
                  {data.map((product) => (
                    <Grid item xs={6} sm={6} md={4} lg={4} key={product.id}>
                      <Card
                        className={`product-card${
                          selectedProduct === product.id ? " selected" : ""
                        }`}
                        onClick={() => setSelectedProduct(product.id)}
                      >
                        <img
                          src={`https://localhost:7245/uploadimages/${product.image}`}
                          alt={product.name}
                          className="product-card-image"
                        />
                        <CardContent className="product-card-content">
                          <Typography variant="h11">
                            {product.productName}
                          </Typography>
                          {(product.categoryId === 9 ||
                            product.categoryId === 2 ||
                            product.categoryId === 3 ||
                            product.categoryId === 4 ||
                            product.categoryId === 5 ||
                            product.categoryId === 6 ||
                            product.categoryId === 7) && (
                            <div className="size-options">
                              <ButtonGroup
                                variant="outlined"
                                size="small"
                                sx={{ ml: 1 }}
                              >
                                <Button
                                  onClick={() =>
                                    handleSizeChange(product.id, "M")
                                  }
                                  sx={{
                                    backgroundColor:
                                      product.selectedSize === "M"
                                        ? color.yellow[400]
                                        : "transparent",
                                  }}
                                >
                                  M
                                </Button>
                                <Button
                                  onClick={() =>
                                    handleSizeChange(product.id, "L")
                                  }
                                  sx={{
                                    backgroundColor:
                                      product.selectedSize === "L"
                                        ? color.yellow[400]
                                        : "transparent",
                                  }}
                                >
                                  L
                                </Button>
                              </ButtonGroup>
                            </div>
                          )}
                        </CardContent>
                        <Button
                          onClick={(e) => handleadd(e, product)}
                          sx={{
                            backgroundColor: color.yellow[400],
                            color: color.grey[100],
                            fontSize: "14px",
                            fontWeight: "bold",
                          }}
                        >
                          Thêm
                        </Button>
                      </Card>
                    </Grid>
                  ))}
                </Grid>
              </div>
            </div>
          </Box>
            <Right selectedProductId={ProductSize} />
        </Box>
      ) : (
        <OrderSell searchOrder={searchQuery} />
      )}
    </div>
  );
}

export default Home;
