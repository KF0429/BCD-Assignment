//src/app/page.tsx

"use client";

import React from "react";
import { Header } from "./components/Header";
import { ActionTab } from "./components/ActionTab";

export default function Home() {
  return (
    <>
      <div className="flex flex-col min-h-screen">
        <Header />
        <div className="flex-grow flex justify-center items-center">
          <ActionTab />
        </div>
      </div>
    </>
  );
}
