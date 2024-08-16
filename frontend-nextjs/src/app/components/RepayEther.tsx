"use client";

import React from "react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import {
  Card,
  CardContent,
  CardDescription,
  CardFooter,
  CardHeader,
} from "@/components/ui/card";

export function RepayEther() {
  return (
    <section className="flex-grow flex justify-center items-center">
      <Card className="w-[350px]">
        <CardHeader>
          <CardDescription className="text-xl font-bold text-white-800">
            Repay
          </CardDescription>
        </CardHeader>
        <CardContent>
          <Input
            className="text-black"
            type="number"
            placeholder="Amount to repay"
          />
        </CardContent>
        <CardFooter>
          <Button className="w-full" variant="outline">
            Continue
          </Button>
        </CardFooter>
      </Card>
    </section>
  );
}

export default RepayEther;
