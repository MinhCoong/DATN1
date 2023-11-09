import { Box, IconButton, Typography, useTheme } from "@mui/material";
import { tokens } from "../../theme";
import InputBase from "@mui/material/InputBase";
import SearchIcon from "@mui/icons-material/Search";
import React from "react";
import { BiLogOut } from "react-icons/bi";
import { Link, useNavigate } from "react-router-dom";
import { AiFillAlert,AiFillLayout } from "react-icons/ai";
import { FaWineGlass } from "react-icons/fa";
import { TiThSmall } from "react-icons/ti";
function Topbar2() {
    const theme = useTheme();
    const colors = tokens(theme.palette.mode);
    const navigate = useNavigate();
    const handleLogout = async (e) => {
        e.preventDefault();
        fetch("https://localhost:7245/v1/api/Authenticate/Logout", {
            method: "POST",
        }).then(res => {
            localStorage.clear()
            navigate("/");
        }).catch((err) => {
            console.log(err.message)
        })
    };
    return (
        <Box display="flex" justifyContent="space-between" p={1} backgroundColor={colors.yellow[400]}>
            <Box display="flex">
                <IconButton>
                    <TiThSmall />
                    <Typography>
                        Tất cả
                    </Typography>
                </IconButton>
                <IconButton>
                    <AiFillAlert />
                    <Typography>
                        Đồ ăn
                    </Typography>
                </IconButton>
                <IconButton>
                    <FaWineGlass />
                    <Typography>
                        Đồ uống
                    </Typography>
                </IconButton>
                {/* <IconButton>
                    <MdPlaylistAddCircle />
                    <Typography>
                        Topping 
                    </Typography>
                </IconButton> */}
            </Box>
            <Box
                display="flex"
                backgroundColor={colors.primary[400]}
                borderRadius="3px"
                width='500px'
            >
                <InputBase sx={{ ml: 2, flex: 1 }} placeholder="Nhập tên mặt hàng" />
                <IconButton type="button" sx={{ p: '0 0 0 10px' }}>
                    <SearchIcon />
                </IconButton>
            </Box>
            
            <Box display='flex'>
                
                <IconButton onClick={handleLogout}>
                    <BiLogOut />
                </IconButton>

            </Box>
        </Box>
    );
};

export default Topbar2;
