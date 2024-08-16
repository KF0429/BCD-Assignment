import React from "react";
import { Connect } from "./Connect";
// import { Navbar } from "./Navbar";
import Link from "next/link";

export function Header() {
  return (
    <header className="flex h-16 w-full items-center justify-between bg-background px-4 md:px-6">
      {/* <MountainIcon className="h-6 w-6" /> */}
      <span className="text-lg font-bold">CryptoLend</span>
      <nav className="hidden gap-6 text-sm font-medium md:flex">
        <Link href="#" className="hover:underline" prefetch={false}>
          DashBooard
        </Link>
        <Link href="#" className="hover:underline" prefetch={false}>
          Marketplace
        </Link>
      </nav>
      <div className="-mx-3 block rounded-lg px-3 py-2.5 text-base font-semibold leading-7 text-fuchsia-700">
        <Connect />
      </div>
    </header>
  );
}
