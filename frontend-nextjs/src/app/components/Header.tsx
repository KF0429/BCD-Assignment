import React from "react";
import { Connect } from "./Connect";

export function Header() {
  return (
    <header className="navbar flex justify-between p-4 pt-0">
      <h1 className="text-xl font-bold">CryptoLend</h1>
      <div className="-mx-3 block rounded-lg px-3 py-2.5 text-base font-semibold leading-7 text-fuchsia-700">
        <Connect />
      </div>
    </header>
  );
}
