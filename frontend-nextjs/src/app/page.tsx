//src/app/page.tsx

"use client";

import React from "react";
import { Header } from "./components/Header";
import { Footer } from "./components/Footer";
import { BuyToken } from "./components/BuyToken";
import { AssetsToBorrow } from "./components/AssetsToBorrow";
import { WithdrawEther } from "./components/WithdrawEther";
import { SuppliedAsset } from "./components/SuppliedAsset";
import { ActionTab } from "./components/ActionTab";

export default function Home() {
  return (
    <>
      <div className="flex flex-col min-h-screen">
        <Header />
        <ActionTab />
        {/* <BuyToken />
        <AssetsToBorrow />
        <WithdrawEther /> */}
        {/* <SuppliedAsset /> */}
        {/* <Footer /> */}
      </div>
    </>
  );
}
