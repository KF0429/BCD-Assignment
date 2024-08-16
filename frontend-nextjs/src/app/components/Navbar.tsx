"use client";
import Link from "next/link";
import React from "react";

export function Navbar() {
  return (
    <nav className="hidden gap-6 text-sm font-medium md:flex">
      <Link href="#" className="hover:underline" prefetch={false}>
        DashBoard
      </Link>
      <Link href="#" className="hover:underline" prefetch={false}>
        MarketPalce
      </Link>
    </nav>
  );
}
