import { Box, Button, IconButton, TextField, useTheme } from '@mui/material';
import React, { useEffect, useState } from 'react';
import { tokens } from '../../theme';
import { FaMoneyCheck } from 'react-icons/fa';
import { GrFormClose } from "react-icons/gr";
import axios from 'axios';
import Select from 'react-select';

function Right({ selectedProductId }) {
    const theme = useTheme();
    const colors = tokens(theme.palette.mode);
    const [prices, setPrices] = useState([]);
    const [toppingoption, setToppingOption] = useState([]);
    const [description, setDescription] = useState("")
    const [tong, settong] = useState(0)
    const [sl, setSl] = useState([1]);
    const [money, setMoney] = useState(0)
    const [keypr, setKeypr] = useState([])
    const [selectedToppings, setSelectedToppings] = useState([]);
    const [token, settoken] = useState(localStorage.getItem("token"))
    const [userId, setuserId] = useState(localStorage.getItem("userId"))
    const setItemQuantity = (key, quantity) => {
        setSl((prevSl) => ({ ...prevSl, [key]: quantity }));
    };

    // Lọc sản phẩm và size của sp
    useEffect(() => {
        if (selectedProductId && selectedProductId.productId) {
            axios
                .get(`https://localhost:7245/Admin/v1/api/prices`, { headers: { 'Authorization': `Bearer ${token}` } })
                .then((response) => {
                    const data = response.data;
                    const filteredData = data.filter(
                        (product) =>
                            product.productId === selectedProductId.productId &&
                            product.sizeId === selectedProductId.sizeId
                    );
                    setPrices((prevPrices) => prevPrices.concat(filteredData));
                    // setSl(Array(filteredData.length).fill(1));
                })
                .catch((error) => {
                    console.log(error);
                });
        }
    }, [selectedProductId]);

    // Tạo key cho mỗi sp khi chọn select không bị trùng
    useEffect(() => {
        let count = 1;
        const newKeypr = prices.map((item) => {
            const key = {
                id: item.id,
                priceOfProduct: item.priceOfProduct,
                product: item.product,
                productId: item.productId,
                sizeId: item.sizeId,
                size: item.size,
                keyproduct: count++
            }
            return key;
        })
        setKeypr(newKeypr);
    }, [prices]);

    useEffect(() => {
        axios.get('https://localhost:7245/Admin/v1/api/topping', { headers: { 'Authorization': `Bearer ${token}` } })
            .then(response => {
                const topping = response.data.map(item => ({
                    value: item.id,
                    label: item.toppingName,
                    price: item.price
                }));
                setToppingOption(topping);
            })
            .catch(error => {
                console.log(error);
            });
    }, []);

    // Xóa dữ liệu trong bảng data
    const handleDeleteRow = (index) => {
        const newPrices = [...prices];
        newPrices.splice(index, 1);
        setPrices(newPrices);
    };

    // Xử lý dư liệu khi chọn trong select topping
    const handleToppingsChange = (value, index) => {
        const newSelectedToppings = [...selectedToppings];
        newSelectedToppings[index] = value;
        setSelectedToppings(newSelectedToppings);

    };

    // Tính tiền của mỗi sp có thêm topping
    useEffect(() => {
        const newMoney = keypr.map((item) => {
            const toppings = selectedToppings[item.keyproduct] || [];
            const toppingPrice = toppings.reduce((total, topping) => total + topping.price, 0);
            const totalPrice = (item.priceOfProduct + toppingPrice) * (sl[item.keyproduct] || 1);
            return totalPrice;
        });
        setMoney(newMoney);
    }, [keypr, selectedToppings, sl]);

    // Lấy dữ liệu của ghi chú
    const handleDescriptionChange = (event) => {
        setDescription(event.target.value);
    };

    // Tính tổng tiền của hóa đơn
    useEffect(() => {
        let tien = 0;
        keypr.forEach(item => {
            const toppings = selectedToppings[item.keyproduct] || [];
            const toppingPrice = toppings.reduce((total, topping) => total + topping.price, 0);
            const totalPrice = (item.priceOfProduct + toppingPrice) * (sl[item.keyproduct] || 1);
            tien += totalPrice;
        });
        settong(tien);
    }, [keypr, selectedToppings, sl]);
    const toppingValues = selectedToppings.map(toppings => toppings ? toppings.map(topping => topping.value) : []);

    // Xử lý nút tính tiền
    const handleTotalPrice = () => {
        let arr = [];
        let cout = 1;
        let tien = 0;
        let quantity = 1;
        console.log(userId)
        keypr.map(item => {
            const product = {
                userId: userId,
                productId: item.productId,
                quantity: sl[quantity++] || 1,
                sizeId: item.sizeId,
                priceProduct: money[tien++],
                description: description,
                toppingSelect: toppingValues[cout++] || []
            }
            arr.push(product);
        })
        fetch("https://localhost:7245/Admin/v1/api/AdminOrders/user", {
            method: "POST",
            headers: { "content-type": "application/json" },
            body: JSON.stringify(arr)
        }).then((res) => {

        }).catch((err) => {
            console.log(err.message)
        })
        console.log(arr)
        // Xóa các state lưu trữ dữ liệu trong table
        setPrices([]);
        setSelectedToppings([]);
        setDescription("");
        setSl([0]);
        setKeypr([]);
        setMoney(0);
        settong(0);
        setToppingOption([])
    }

    return (
        <div>
            <Box
                gridColumn="span 1"
                sx={{ height: '91vh' }}

            >
                <Box sx={{ height: '70vh', width: '100%', overflow: 'auto' }}>
                    <table style={{ width: '100%', borderCollapse: 'collapse' }}>
                        <thead>
                            <tr>
                                <th style={{ width: '25%', borderBottom: '1px solid #ccc', padding: '10px', textAlign: 'left' }}>Sản phẩm</th>
                                <th style={{ width: '5%', borderBottom: '1px solid #ccc', padding: '10px', textAlign: 'center' }}>Size</th>
                                <th style={{ width: '10%', borderBottom: '1px solid #ccc', padding: '10px', textAlign: 'center' }}>Đơn giá</th>
                                <th style={{ width: '10%', borderBottom: '1px solid #ccc', padding: '10px', textAlign: 'center' }}>SL</th>
                                <th style={{ width: '25%', borderBottom: '1px solid #ccc', padding: '10px', textAlign: 'left' }}>Topping</th>
                                <th style={{ width: '10%', borderBottom: '1px solid #ccc', padding: '10px', textAlign: 'center' }}>Thành tiền</th>
                                <th style={{ width: '5%', borderBottom: '1px solid #ccc', padding: '10px' }}></th>
                            </tr>
                        </thead>
                        <tbody>
                            {keypr.map((item, index) => {
                                const toppings = selectedToppings[item.keyproduct] || [];
                                const toppingPrice = toppings.reduce((total, topping) => total + topping.price, 0);
                                const totalPrice = (item.priceOfProduct + toppingPrice) * (sl[item.keyproduct] || 1);
                                return (
                                    <tr key={index} style={{ borderBottom: '1px solid #ccc' }}>
                                        <td style={{ width: '25%', borderRight: '1px solid #ccc', padding: '10px', textAlign: 'left' }}>{item.product.productName.toString()}</td>
                                        <td style={{ width: '5%', borderRight: '1px solid #ccc', padding: '10px', textAlign: 'center' }}>{item.size.sizeName.toString()}</td>
                                        <td style={{ width: '10%', borderRight: '1px solid #ccc', padding: '10px', textAlign: 'right' }}>{new Intl.NumberFormat("vi-VN", {
                                            style: "currency",
                                            currency: "VND",
                                        }).format(item.priceOfProduct)}</td>
                                        <td style={{ width: '10%', borderRight: '1px solid #ccc', padding: '10px', textAlign: 'center' }}>
                                            <input type="number" min="1" value={sl[item.keyproduct] || 1} onChange={(event) => {
                                                setItemQuantity(item.keyproduct, event.target.value);
                                            }} style={{ width: '100%' }} />
                                        </td>
                                        <td style={{ width: '25%', borderRight: '1px solid #ccc', padding: '10px', textAlign: 'left' }}>
                                            <Select
                                                key={index}
                                                isMulti
                                                options={toppingoption}
                                                className="basic-multi-select"
                                                classNamePrefix="select"
                                                style={{ width: '100%', height: 30, maxHeight: 200, overflow: 'auto' }}
                                                onChange={(value) => handleToppingsChange(value, item.keyproduct)}
                                                value={selectedToppings[item.keyproduct]}
                                            />
                                        </td>

                                        <td style={{ width: '10%', borderRight: '1px solid #ccc', padding: '10px', textAlign: 'right' }}>
                                            {}{new Intl.NumberFormat("vi-VN", {
              style: "currency",
              currency: "VND",
            }).format(totalPrice)}
                                        </td>
                                        <td style={{ textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' }}>
                                            <IconButton onClick={() => handleDeleteRow(index)}>
                                                <GrFormClose />
                                            </IconButton>
                                        </td>
                                    </tr>
                                )
                            }
                            )}
                        </tbody>
                    </table>
                </Box>

                <Box display='flex'>
                    <Box
                        sx={{ m: "5px 0 0 0 " }}
                    >
                        <div style={{ display: 'flex', alignItems: 'center', }}>
                            <TextField
                                style={{ backgroundColor: 'white', flex: 1 }}
                                id="outlined-multiline-static"
                                multiline
                                rows={4}
                                columns={6}
                                defaultValue="Ghi chú"
                                onChange={handleDescriptionChange}
                            />
                            <div style={{ marginLeft: '100px' }}>
                                <label><b>Tổng tiền:</b></label>

                                <label><b>{}{new Intl.NumberFormat("vi-VN", {
              style: "currency",
              currency: "VND",
            }).format(tong)}</b></label>


                            </div>
                        </div>
                        <Box display="flex" sx={{ m: "5px 0 0 0 " }}>
                            <Button
                                sx={{
                                    backgroundColor: colors.yellow[500],
                                    color: colors.grey[100],
                                    fontSize: "14px",
                                    fontWeight: "bold",
                                    padding: "10px 20px",
                                }}
                                startIcon={<FaMoneyCheck />}
                                onClick={handleTotalPrice}
                            >
                                Tính tiền
                            </Button>

                        </Box>
                    </Box>
                </Box>

            </Box>
        </div >
    );
}

export default Right;