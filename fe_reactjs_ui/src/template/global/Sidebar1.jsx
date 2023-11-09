import React from 'react'
import { Sidebar, Menu, MenuItem, useProSidebar } from 'react-pro-sidebar';
import { Box, IconButton, Typography, useTheme } from "@mui/material";
import { useState } from "react";
import { tokens } from "../../theme";
import { Link } from "react-router-dom";
import HomeOutlinedIcon from "@mui/icons-material/HomeOutlined";
import PeopleOutlinedIcon from "@mui/icons-material/PeopleOutlined";
import ReceiptOutlinedIcon from "@mui/icons-material/ReceiptOutlined";
import MenuOutlinedIcon from "@mui/icons-material/MenuOutlined";
import { BiFoodMenu, BiMoney, BiNews } from "react-icons/bi";
import { AiTwotoneAppstore, AiFillHome, AiTwotoneAlert,AiFillNotification,AiTwotoneRest} from "react-icons/ai";
import { RiCoupon2Fill } from "react-icons/ri";
import { CgSize } from "react-icons/cg";
import { FaImages } from "react-icons/fa";
const Item = ({ title, icon, selected, setSelected }) => {
  return (
    <MenuItem
      active={selected === title}
      onClick={() => setSelected(title)}
      icon={icon}
    >
      <Typography fontWeight="bold" variant="h4">{title}</Typography>

    </MenuItem>
  )
}

function Sidebar1() {
  const { collapseSidebar } = useProSidebar();
  const [selected, setSelected] = useState("Dashboard");
  const [isCollapsed] = useState(false);
  const theme = useTheme();
  const colors = tokens(theme.palette.mode);
  return (
    <div>
      <Sidebar
        // breakPoint="lg" 
        collapsed={isCollapsed}
        style={{ height: "100%" }}
        backgroundColor={colors.primary[400]}
        width='230px'
      >
        <Menu  >
          {/* Logo  */}
          <MenuItem

            //  icon={<MenuOutlinedIcon /> }
            style={{
              margin: "10px 0 10px 0",
            }}
          >
            {!isCollapsed && (
              <Box
                display="flex"
                alignItems="center"
                ml="5px"
              >
                <IconButton onClick={() => collapseSidebar()}>
                  <MenuOutlinedIcon />
                </IconButton>
                <Typography variant="h3" color={colors.red} fontWeight="bold" paddingLeft='20px'>
                  ADMIN
                </Typography>

              </Box>
            )}
          </MenuItem>

         
          <Box paddingLeft={isCollapsed ? undefined : "5%"} >
            <Link to="/MrSoai/" style={{ color: colors.grey[100], }}>
              <Item
                title="Trang chủ"
                icon={<HomeOutlinedIcon />}
                selected={selected}
                setSelected={setSelected}
              />
            </Link>
            <Link to="/MrSoai/member" style={{ color: colors.grey[100] }}>
              <Item
                title="Nhân Viên"
                icon={<PeopleOutlinedIcon />}
                selected={selected}
                setSelected={setSelected}
              />
            </Link>
            <Link to="/MrSoai/customer" style={{ color: colors.grey[100] }}>
              <Item
                title="Khách hàng"
                icon={<PeopleOutlinedIcon />}
                selected={selected}
                setSelected={setSelected}
              />
            </Link>
            <Link to="/MrSoai/product" style={{ color: colors.grey[100] }}>
              <Item
                title="Sản Phẩm"
                icon={<BiFoodMenu />}
                selected={selected}
                setSelected={setSelected}
              />
            </Link>
            <Link to="/MrSoai/type" style={{ color: colors.grey[100] }}>
              <Item
                title="Loại sản Phẩm"
                icon={<AiTwotoneAppstore />}
                selected={selected}
                setSelected={setSelected}
              />
            </Link>
            <Link to="/MrSoai/size" style={{ color: colors.grey[100] }}>
              <Item
                title="Size"
                icon={<CgSize />}
                selected={selected}
                setSelected={setSelected}
              />
            </Link>
            <Link to="/MrSoai/price" style={{ color: colors.grey[100] }}>
              <Item
                title="Giá tiền"
                icon={<BiMoney />}
                selected={selected}
                setSelected={setSelected}
              />
            </Link>
            <Link to="/MrSoai/topping" style={{ color: colors.grey[100] }}>
              <Item
                title="Topping"
                icon={<AiTwotoneAlert />}
                selected={selected}
                setSelected={setSelected}
              />
            </Link>
            <Link to="/MrSoai/categorytopping" style={{ color: colors.grey[100] }}>
              <Item
                title="Loại Topping"
                icon={<AiTwotoneAlert />}
                selected={selected}
                setSelected={setSelected}
              />
            </Link>
            <Link to="/MrSoai/news" style={{ color: colors.grey[100] }}>
              <Item
                title="Tin tức"
                icon={<BiNews />}
                selected={selected}
                setSelected={setSelected}
              />
            </Link>
            <Link to="/MrSoai/coupon" style={{ color: colors.grey[100] }}>
              <Item
                title="Mã khuyến mãi"
                icon={<RiCoupon2Fill />}
                selected={selected}
                setSelected={setSelected}
              />
            </Link>
            <Link to="/MrSoai/slider" style={{ color: colors.grey[100] }}>
              <Item
                title="Slider"
                icon={<FaImages />}
                selected={selected}
                setSelected={setSelected}
              />
            </Link>
            <Link to="/MrSoai/invoice" style={{ color: colors.grey[100] }}>
              <Item
                title="Hóa đơn"
                icon={<ReceiptOutlinedIcon />}
                selected={selected}
                setSelected={setSelected}
              />
            </Link>
            <Link to="/MrSoai/suppliers" style={{ color: colors.grey[100] }}>
              <Item
                title="Nhà cung cấp"
                icon={<AiFillHome />}
                selected={selected}
                setSelected={setSelected}
              />
            </Link>
            <Link to="/MrSoai/notification" style={{ color: colors.grey[100] }}>
              <Item
                title="Thông báo"
                icon={<AiFillNotification />}
                selected={selected}
                setSelected={setSelected}
              />
            </Link>
            <Link to="/MrSoai/quantums" style={{ color: colors.grey[100] }}>
              <Item
                title="Định lượng"
                icon={<AiTwotoneRest />}
                selected={selected}
                setSelected={setSelected}
              />
            </Link>
            <Link to="/MrSoai/ware" style={{ color: colors.grey[100] }}>
              <Item
                title="Kho"
                icon={<AiFillHome />}
                selected={selected}
                setSelected={setSelected}
              />
            </Link>

          </Box>
        </Menu>
      </Sidebar>

    </div>
  )
}

export default Sidebar1