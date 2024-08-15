// src/app/components/Header.tsx
"use client";

import React, { useState } from "react";
import { useRouter } from "next/navigation";
import { Connect } from "./Connect";

export function Header() {
  const [showLoanPage, setShowLoanPage] = useState(false);
  const router = useRouter();

  const handleToggle = () => {
    setShowLoanPage(!showLoanPage);
    if (!showLoanPage) {
      router.push("/loan"); // Navigate to loan page
    } else {
      router.push("/"); // Navigate back to home page or previous page
    }
  };

  return (
    <header className="navbar flex justify-between p-4 pt-0">
      <h1 className="text-xl font-bold">😊</h1>
      <div className="flex gap-2">
        <button
          onClick={handleToggle}
          className="py-2 px-4 bg-indigo-500 text-white rounded-md hover:bg-indigo-700"
        >
          {showLoanPage ? "Hide Loan Details" : "Show Loan Details"}
        </button>
        <Connect />
      </div>
    </header>
  );
}
