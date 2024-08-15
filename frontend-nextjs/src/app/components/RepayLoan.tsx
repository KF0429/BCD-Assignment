"use client";

import {
  useSimulateContract,
  useWriteContract,
  useWaitForTransactionReceipt,
} from "wagmi";
import { Address, parseEther } from "viem";
import { useState, useEffect } from "react";
import { print } from "@/utils/toast";
import LendingPoolABI from "@/abi/LendingPool.json";
import { lendingPoolAddress } from "@/utils/smartContractAddress";

export function RepayLoan() {
  const contractAddress = lendingPoolAddress as Address;
  const [amount, setAmount] = useState("0.01");

  // Simulate contract call to estimate gas and check errors
  const { error: estimateError } = useSimulateContract({
    address: contractAddress ?? undefined,
    abi: LendingPoolABI.abi,
    functionName: "repayLoan",
    value: parseEther(amount),
  });

  // Write contract for executing the transaction
  const { data, writeContract } = useWriteContract();

  const { error: txError, isSuccess: txSuccess } = useWaitForTransactionReceipt(
    {
      hash: data,
    }
  );

  // Handle transaction
  const handleRepayTransaction = () => {
    // Convert amount to a number and validate
    const repayAmount = parseFloat(amount);
    if (repayAmount <= 0) {
      print(`Amount must be greater than 0`, "error");
      return;
    }

    if (estimateError) {
      print(`Transaction failed: ${estimateError.message}`, "error");
      return;
    }

    // Notify user that the transaction is in progress
    print(`Repayment process started`, "info");

    writeContract({
      address: contractAddress ?? undefined,
      abi: LendingPoolABI.abi,
      functionName: "repayLoan",
      value: parseEther(amount),
    });
  };

  // Handle amount input change
  const handleQuantityInput = (e: React.ChangeEvent<HTMLInputElement>) => {
    setAmount(e.target.value);
  };

  // Update UI based on transaction success or error
  useEffect(() => {
    if (txSuccess) {
      print(`Transaction successful`, "success");
    } else if (txError) {
      print(`Transaction failed: ${txError.message}`, "error");
    }
  }, [txSuccess, txError]);

  // Check if the amount is valid to enable/disable the button
  const isAmountValid = parseFloat(amount) > 0;

  return (
    <section className="flex-grow flex justify-center items-center">
      <div className="card shadow-md rounded-lg overflow-hidden max-w-sm">
        <div className="p-4">
          <h6 className="text-xl font-bold text-white-800">Repay Loan</h6>
          <div className="flex mt-4">
            <input
              onChange={handleQuantityInput}
              type="number"
              className="text-black w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-1 focus:ring-indigo-500"
              placeholder="Enter amount"
              step="0.01"
              value={amount}
            />
            <button
              onClick={handleRepayTransaction}
              disabled={!isAmountValid}
              className={`ml-2 py-2 px-4 rounded-md ${
                isAmountValid
                  ? "bg-indigo-500 text-white hover:bg-indigo-700"
                  : "bg-gray-400 text-gray-700 cursor-not-allowed"
              } focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500`}
            >
              Repay
            </button>
          </div>
        </div>
      </div>
    </section>
  );
}
