import React, { useState } from 'react';
import { CssBaseline, ThemeProvider } from "@mui/material";
import { Outlet, RouterProvider, createBrowserRouter } from "react-router-dom";
import { ColorModeContext, useMode } from "./theme";
import Dashboard from "./page/Dashboard";
import Login from "./page/Login";
import Member from "./page/Member/index";
import Product from "./page/Product";
import Sidebar1 from './template/global/Sidebar1';
import Topbar from './template/global/Topbar';
import Ware from './page/Ware';
import Type from './page/Type';
import Size from './page/Size';
import Price from './page/Price';
import Topping from './page/Topping';
import Customer from './page/Customer';
import CreateMember from './page/Member/create';
import EditMember from './page/Member/edit';
import CreateProduct from './page/Product/create';
import EditProduct from './page/Product/edit';
import CreateT from './page/Type/create';
import EditT from './page/Type/edit';
import CreateS from './page/Size/create';
import EditS from './page/Size/edit';
import CreatePr from './page/Price/create';
import EditPr from './page/Price/edit';
import CreateTo from './page/Topping/create';
import EditTo from './page/Topping/edit';
import Invoice from './page/Invoice';
import Home from './page/Sell/Home';
import News from './page/News';
import CreateNews from './page/News/create';
import EditNews from './page/News/edit';
import Coupon from './page/Coupon';
import CreateCoupon from './page/Coupon/create';
import EditCoupon from './page/Coupon/edit';
import CreateWare from './page/Ware/create';
import OrderWare from './page/Ware/orderWare';
import Slider from './page/Silder';
import CreateSlider from './page/Silder/create';
import EditSlider from './page/Silder/edit';
import Suppliers from './page/Suppliers';
import CreateSuppliers from './page/Suppliers/create';
import EditSuppliers from './page/Suppliers/edit';
import EditWare from './page/Ware/edit';
import CreateIn from './page/Ware/createIn';
import Notification from './page/Notificattion';
import CreateNotifi from './page/Notificattion/create';
import EditMemberT from './page/Member/editT';
import Inventory from './page/Ware/inventory';
import InventoryCheck from './page/Ware/inventorycheck';
import Quantums from './page/Quantum';
import CreateQ from './page/Quantum/create';
import EditQ from './page/Quantum/edit';
import CategoryTopping from './page/CategoryTopping'; 
import CreateCT from './page/CategoryTopping/create';
import EditCT from './page/CategoryTopping/edit';
import Kiemke from './page/Ware/kiemke';
const App = () => {
  const [theme, colorMode] = useMode();
  const [isSidebar, setIsSidebar] = useState(true);
  const App = () => {
    return (
      <ColorModeContext.Provider value={colorMode}>
        <ThemeProvider theme={theme}>
          <CssBaseline />
          <div className="app">
            <Sidebar1 isSidebar={isSidebar} />
            <main className="content">
              <Topbar setIsSidebar={setIsSidebar} />
              <Outlet />
            </main>
          </div>
        </ThemeProvider>
      </ColorModeContext.Provider>
    );
  };



  const router = createBrowserRouter([
    {
      path: "/",
      element: <Login />,
    },
    {
      path: "/MrSoai",
      element: <App />,
      children: [
        {
          path: "/MrSoai/",
          element: <Dashboard />,
        },
        {
          path: "/MrSoai/member",
          element: <Member />,
        },
        {
          path: "/MrSoai/quantums",
          element: <Quantums />,
        },
        {
          path: "/MrSoai/product",
          element: <Product />,
        },
        {
          path: "/MrSoai/ware",
          element: <Ware />,
        },
        {
          path: "/MrSoai/type",
          element: <Type />,
        },
        {
          path: "/MrSoai/size",
          element: <Size />,
        },
        {
          path: "/MrSoai/price",
          element: <Price />,
        },
        {
          path: "/MrSoai/topping",
          element: <Topping />,
        },
        {
          path: "/MrSoai/coupon",
          element: <Coupon />,
        },
        {
          path: "/MrSoai/news",
          element: <News />,
        },
        {
          path: "/MrSoai/customer",
          element: <Customer />,
        },
        {
          path: "/MrSoai/slider",
          element: <Slider />,
        },
        {
          path: "/MrSoai/createM",
          element: <CreateMember />,
        },
        {
          path: "/MrSoai/editM/:id",
          element: <EditMember />,
        },
        {
          path: "/MrSoai/editMT/:id",
          element: <EditMemberT />,
        },
        {
          path: "/MrSoai/createP",
          element: <CreateProduct />,
        },
        {
          path: "/MrSoai/editP/:id",
          element: <EditProduct />,
        },
        {
          path: "/MrSoai/createT",
          element: <CreateT />,
        },
        {
          path: "/MrSoai/editT/:id",
          element: <EditT />,
        },
        {
          path: "/MrSoai/createS",
          element: <CreateS />,
        },
        {
          path: "/MrSoai/editS/:id",
          element: <EditS />,
        },
        {
          path: "/MrSoai/createPr",
          element: <CreatePr />,
        },
        {
          path: "/MrSoai/editPr/:id",
          element: <EditPr />,
        },
        {
          path: "/MrSoai/createTo",
          element: <CreateTo />,
        },
        {
          path: "/MrSoai/editTo/:id",
          element: <EditTo />,
        },
        {
          path: "/MrSoai/invoice",
          element: <Invoice />,
        },

        {
          path: "/MrSoai/createNews",
          element: <CreateNews />,
        },
        {
          path: "/MrSoai/editNews/:id",
          element: <EditNews />,
        },
        {
          path: "/MrSoai/createCouupon",
          element: <CreateCoupon />,
        },
        {
          path: "/MrSoai/editCoupon/:id",
          element: <EditCoupon />,
        },
        {
          path: "/MrSoai/createW",
          element: <CreateWare />,
        },
        {
          path: "/MrSoai/watchW",
          element: <OrderWare />,
        },
        {
          path: "/MrSoai/createSlider",
          element: <CreateSlider />,
        },
        {
          path: "/MrSoai/editSlider/:id",
          element: <EditSlider />,
        },
        {
          path: "/MrSoai/suppliers",
          element: <Suppliers />,
        },
        {
          path: "/MrSoai/createSuppliers",
          element: <CreateSuppliers />,
        },
        {
          path: "/MrSoai/editSuppliers/:id",
          element: <EditSuppliers />,
        },
        {
          path: "/MrSoai/editWare/:id",
          element: <EditWare />,
        },
        {
          path: "/MrSoai/createIn",
          element: <CreateIn />,
        },
        {
          path: "/MrSoai/notification",
          element: <Notification />,
        },
        {
          path: "/MrSoai/createNoti",
          element: <CreateNotifi />,
        },
        {
          path: "/MrSoai/inventory",
          element: <Inventory />,
        },  
        {
          path: "/MrSoai/inventorycheck",
          element: <InventoryCheck />,
        },  
        {
          path: "/MrSoai/editQ/:id",
          element: <EditQ />,
        },
        {
          path: "/MrSoai/createQ",
          element: <CreateQ />,
        },
        {
          path: "/MrSoai/categorytopping",
          element: <CategoryTopping />,
        },
        {
          path: "/MrSoai/editCT/:id",
          element: <EditCT />,
        },
        {
          path: "/MrSoai/createCT",
          element: <CreateCT />,
        },
        {
          path: "/MrSoai/kiemke",
          element: <Kiemke />,
        },
      ]
    },


    {
      path: "/MrSoai/home",
      element: <Home />,
    },
  ]);
  return (
    <div>
      <RouterProvider router={router} />
    </div>

  );  
}

export default App;
