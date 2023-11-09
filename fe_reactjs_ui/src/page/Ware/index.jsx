import * as React from "react";
import { Box, Button, useTheme, colors } from "@mui/material";
import { DataGrid, GridColDef } from "@mui/x-data-grid";
import { tokens } from "../../theme";
import { Typography } from "@mui/material";
import { MdAddCircle } from "react-icons/md";
import { Link, useNavigate } from "react-router-dom";
import { useEffect, useState } from "react";
import axios from "axios";
import { BsFillGearFill } from "react-icons/bs";
import { AiFillDelete } from "react-icons/ai";

export default function Ware() {
  const [data, setData] = useState([]);
  const [dataTrue, setDataTrue] = useState([]);
  const theme = useTheme();
  const color = tokens(theme.palette.mode);
  const history = useNavigate();
  useEffect(() => {
    axios
      .get("https://localhost:7245/Admin/v1/api/Ingredients")
      .then((response) => {
        setData(response.data);
      })
      .catch((error) => {
        console.log(error);
      });
  }, []);

  useEffect(() => {
    let arr = [];
    data.map((item) => {
      if (item.status) {
        arr.push(item);
      }
    });
    setDataTrue(arr);
  }, [data]);
  const handleEditClick = (id) => {
    history(`/MrSoai/editWare/${id}`, {
      state: { data: data.filter((item) => item.id === id)[0] },
    });
    // history(`/editT/${id}`);
  };
  const columns: GridColDef[] = [
    {
      field: "ingredientName",
      headerName: "Tên nguyên liệu",
      width: 130,
      editable: true,
      flex: 1,
    },
    {
      field: "unit",
      headerName: "Đơn vị",
      width: 130,
      editable: true,
      flex: 1,
    },
    {
      field: "quantity",
      headerName: "Số lượng",
      width: 110,
      editable: true,
      flex: 1,
    },
    {
      field: "button",
      headerName: "Chức năng",
      width: 200,
      renderCell: ({ row: { access, id } }) => {
        return (
          <Box
            display="flex"
            justifyContent="space-between"
            alignItems="center"
          >
            <Button
              onClick={() => {
                handleEditClick(id);
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
                  axios
                    .delete(
                      `https://localhost:7245/Admin/v1/api/Ingredients/${id}`
                    )
                    .then((response) => {
                      console.log(response.data);
                      window.location.reload();
                    })
                    .catch((error) => {
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
          Kho
        </Typography>
      </Box>
      <Box m="10px" display="flex">
        <Link to="/MrSoai/createIn">
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
            Thêm nguyên liệu
          </Button>
        </Link>
        <Box m={2} />
        <Link to="/MrSoai/createW">
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
            Thêm hóa đơn nhập
          </Button>
        </Link>
        <Box m={2}></Box>
        <Link to="/MrSoai/watchW">
          <Button
            sx={{
              backgroundColor: color.blueAccent[700],
              color: color.grey[100],
              fontSize: "14px",
              fontWeight: "bold",
              padding: "10px 20px",
            }}
          >
            Xem hóa đơn nhập
          </Button>
        </Link>
        <Box m={2}></Box>
        <Link to="/MrSoai/inventory">
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
            Xuất kho
          </Button>
        </Link>
        <Box m={2}></Box>
        <Link to="/MrSoai/inventorycheck">
          <Button
            sx={{
              backgroundColor: color.blueAccent[700],
              color: color.grey[100],
              fontSize: "14px",
              fontWeight: "bold",
              padding: "10px 20px",
            }}
            
          >
            Xem xuất kho
          </Button>
        </Link>
        <Box m={2}></Box>
        <Link to="/MrSoai/kiemke">
          <Button
            sx={{
              backgroundColor: color.blueAccent[700],
              color: color.grey[100],
              fontSize: "14px",
              fontWeight: "bold",
              padding: "10px 20px",
            }}
            
          >
           Kiểm kê
          </Button>
        </Link>
        
      </Box>
      <Box
        sx={{ height: "70vh", width: "100%" }}
        display="flex"
        justifyContent="space-between"
      >
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
