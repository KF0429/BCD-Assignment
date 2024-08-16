"use client";
import {
  useSimulateContract,
  useWriteContract,
  useWaitForTransactionReceipt,
} from "wagmi";
import { useState, useEffect } from "react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Address, parseEther } from "viem";
import {
  Card,
  CardContent,
  CardDescription,
  CardFooter,
  CardHeader,
} from "@/components/ui/card";
import lendingpool from "@/abi/lendingPool.json";
import { lendingPoolAddress } from "@/utils/smartContractAddress";
import { print } from "@/utils/toast";

export function BuyToken() {
  const contractAddress = lendingPoolAddress as Address;
  const [amount, setAmount] = useState("0.01");

  const { error: estimateError } = useSimulateContract({
    address: contractAddress ?? undefined,
    abi: lendingpool.abi,
    functionName: "Supply",
    value: parseEther(amount),
  });

  const { data, writeContract } = useWriteContract();

  const { error: txError, isSuccess: txSuccess } = useWaitForTransactionReceipt(
    {
      hash: data,
    }
  );

  const handleBuyTransaction = () => {
    if (estimateError) {
      print(`Transaction failed: ${estimateError.cause}`, "error");
      return;
    }
    console.log("error123");
    writeContract({
      address: contractAddress ?? undefined,
      abi: lendingpool.abi,
      functionName: "Supply",
      value: parseEther(amount),
    });
  };

  const handleQuantityInput = (e: React.ChangeEvent<HTMLInputElement>) => {
    setAmount(e.target.value);
  };

  useEffect(() => {
    if (txSuccess) {
      print(`Transaction successful`, "success");
    } else if (txError) {
      print(`Transaction failed: ${txError.cause}`, "error");
    }
  }, [txSuccess, txError]);

  return (
    <section className="flex-grow flex justify-center items-center">
      <Card className="w-[350px]">
        <CardHeader>
          <CardDescription className="text-xl font-bold text-white-800">
            Asset To Supply
          </CardDescription>
        </CardHeader>
        <CardContent>
          <Input
            onChange={(e) => handleQuantityInput(e)}
            className="text-black"
            type="number"
            placeholder="Amount to supply"
          />
        </CardContent>
        <CardFooter>
          <Button
            onClick={handleBuyTransaction}
            className="w-full dark:bg-purple-600 dark:hover:bg-purple-700 dark:focus:ring-purple-900"
            variant="outline"
          >
            Continue
          </Button>
        </CardFooter>
      </Card>
    </section>
  );
}

export default BuyToken;
