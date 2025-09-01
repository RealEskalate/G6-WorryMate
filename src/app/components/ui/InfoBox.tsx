import React from "react";
import {
  IoWarningOutline,
  IoInformationCircleOutline,
  IoMegaphoneOutline,
} from "react-icons/io5";

interface InfoBoxProps {
  message: string;
  type: "warning" | "info" | "announcement";
}

const InfoBox: React.FC<InfoBoxProps> = ({ message, type }) => {
  const containerClasses = `
    flex items-start rounded-lg p-3 border-2
    ${type === "warning" ? "bg-red-50 border-red-400 text-red-700" : ""}
    ${type === "info" ? "bg-yellow-50 border-yellow-400 text-yellow-700" : ""}
    ${type === "announcement" ? "bg-blue-50 border-blue-400 text-blue-700" : ""}
  `;

  const Icon = () => {
    if (type === "warning") {
      return <IoWarningOutline className="h-5 w-5 mr-2 mt-0.5 shrink-0" />;
    }
    if (type === "info") {
      return (
        <IoInformationCircleOutline className="h-5 w-5 mr-2 mt-0.5 shrink-0" />
      );
    }
    if (type === "announcement") {
      return <IoMegaphoneOutline className="h-5 w-5 mr-2 mt-0.5 shrink-0" />;
    }
    return null; // Fallback
  };

  return (
    <div className={containerClasses}>
      <Icon />
      <p className="text-sm font-medium">{message}</p>
    </div>
  );
};

export default InfoBox;
