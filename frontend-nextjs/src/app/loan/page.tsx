// src/app/loan/page.tsx
"use client";

import React from "react";
import { useRouter } from "next/navigation"; // Adjusted import
import { LoanDetails } from "@/app/components/LoanDetails";
import { RepayLoan } from "@/app/components/RepayLoan";

export default function LoanPage() {
  const router = useRouter();

  const handleGoBack = () => {
    router.back();
  };

  return (
    <div className="p-4">
      <button
        onClick={handleGoBack}
        className="mb-4 py-2 px-4 bg-gray-500 text-white rounded-md hover:bg-gray-700"
      >
        Go Back
      </button>
      <LoanDetails />
      <RepayLoan />
    </div>
  );
}
