import React from "react";

interface MyCardProps {
  icon?: React.ReactNode; // optional icon/logo
  type?: string; // e.g., "Website", "Email", "LinkedIn"
  info?: string; // e.g., "https://mhs-et.org" or "contact@email.com"
  small?: boolean;
}

const MyCard = ({ icon, type, info, small }: MyCardProps) => {
  return (
    <div
      className={`flex items-center gap-2 bg-red-50 border border-red-200 rounded-lg ${
        small ? "px-2 py-1 max-w-xs" : "px-6 py-4 max-w-md"
      }`}
    >
      {icon && (
        <div className={small ? "text-black text-base" : "text-black text-xl"}>
          {icon}
        </div>
      )}
      <span
        className={
          small
            ? "text-xs font-medium text-red-700"
            : "text-sm font-medium text-red-700"
        }
      >
        {type}
      </span>
      <span
        className={
          small
            ? "text-[#A77A76] text-xs truncate max-w-[100px]"
            : "text-[#A77A76] text-sm truncate max-w-[220px]"
        }
      >
        {info}
      </span>
    </div>
  );
};

export default MyCard;
