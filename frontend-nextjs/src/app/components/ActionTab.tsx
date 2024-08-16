import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import React from "react";
import { BuyToken } from "@/app/components/BuyToken";
import AssetsToBorrow from "@/app/components/AssetsToBorrow";
import WithdrawEther from "@/app/components/WithdrawEther";
import RepayEther from "@/app/components/RepayEther";

export function ActionTab() {
  return (
    <div className="flex items-center justify-center">
      <Tabs defaultValue="account" className="w-[400px]">
        <TabsList className="grid w-full grid-cols-4 justify-center ">
          <TabsTrigger
            className="hover:bg-violet-600 active:bg-violet-700 focus:outline-none focus:ring focus:ring-violet-300"
            value="supply"
          >
            Supply
          </TabsTrigger>
          <TabsTrigger
            className="hover:bg-violet-600 active:bg-violet-700 focus:outline-none focus:ring focus:ring-violet-300"
            value="borrow"
          >
            Borrow
          </TabsTrigger>
          <TabsTrigger
            className="hover:bg-violet-600 active:bg-violet-700 focus:outline-none focus:ring focus:ring-violet-300"
            value="withdraw"
          >
            Withdraw
          </TabsTrigger>
          <TabsTrigger
            className="hover:bg-violet-600 active:bg-violet-700 focus:outline-none focus:ring focus:ring-violet-300"
            value="repay"
          >
            Repay
          </TabsTrigger>
        </TabsList>
        <TabsContent value="supply" className="p-4">
          <BuyToken />
        </TabsContent>
        <TabsContent value="borrow" className="p-4">
          <AssetsToBorrow />
        </TabsContent>
        <TabsContent value="withdraw" className="p-4">
          <WithdrawEther />
        </TabsContent>
        <TabsContent value="repay" className="p-4">
          <RepayEther />
        </TabsContent>
      </Tabs>
    </div>
  );
}
export default ActionTab;
