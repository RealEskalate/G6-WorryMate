import {
  Card,
  CardAction,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import React from "react";
import { HiOutlinePhone } from "react-icons/hi2";
import { FiGlobe } from "react-icons/fi";
import MyCard from "../DisplayInfo";
import { MdOutlineEmail } from "react-icons/md";
import { FiPhone } from "react-icons/fi";

interface contactCardProps {
  name: string;
  availability?: string;
  phone?: string;
  website?: string;
  email?: string;
  onButtonClick?: () => void;
}

const contactCard = ({
  name,
  availability,
  phone,
  website,
  email,
  onButtonClick,
}: contactCardProps) => {
  return (
    <Card className="w-full h-auto rounded-lg overflow-hidden max-w-sm mx-auto gap-0 p-0">
      <CardHeader className="bg-red-600 p-1 text-white items-center flex justify-between">
        <CardTitle className="text-base">{name}</CardTitle>
        <span className="rounded-sm bg-red-100 text-black px-1.5 py-0.5 text-xs">
          Hours: {availability || "N/A"}
        </span>
      </CardHeader>
      <CardContent className="space-y-1 p-2">
        <MyCard type="Website" info={website || "N/A"} small />
        <MyCard
          type="Email"
          info={email || "N/A"}
          small
        />
        <MyCard type="Phone" info={phone || "N/A"} small />
      </CardContent>
    </Card>
  );
};

export default contactCard;
