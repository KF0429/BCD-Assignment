"use client";

import React, { useState, useEffect } from "react";
import { useContractRead } from "wagmi";
import { Address } from "viem";
import LendingPoolABI from "@/abi/LendingPool.json";
import { lendingPoolAddress } from "@/utils/smartContractAddress";
import { print } from "@/utils/toast";

export function LoanDetails() {
  const contractAddress = lendingPoolAddress as Address;
  const [loanDetails, setLoanDetails] = useState<any>(null);

  const { data, error, isSuccess } = useContractRead({
    address: contractAddress,
    abi: LendingPoolABI.abi,
    functionName: "getLoanDetails", // Replace with the correct function name
  });

  useEffect(() => {
    if (isSuccess) {
      console.log("Loan details fetched successfully:", data);
      setLoanDetails(data);
    } else if (error) {
      console.error("Error fetching loan details:", error);
      print(`Failed to fetch loan details: ${error.message}`, "error");
    }
  }, [data, error, isSuccess]);

  return (
    <section className="flex-grow flex justify-center items-center">
      <div className="card shadow-md rounded-lg overflow-hidden max-w-sm">
        <div className="p-4">
          <h6 className="text-xl font-bold text-white-800">Loan Details</h6>
          <div className="mt-4">
            {loanDetails ? (
              <div>
                <p>
                  <strong>Amount Borrowed:</strong> {loanDetails.amountBorrowed}
                </p>
                <p>
                  <strong>Remaining Balance:</strong>{" "}
                  {loanDetails.remainingBalance}
                </p>
                <p>
                  <strong>Status:</strong> {loanDetails.status}
                </p>
              </div>
            ) : (
              <p>No loan details available.</p>
            )}
          </div>
        </div>
      </div>
    </section>
  );
}
