'use client'
import React, { useState, useEffect } from "react";
import { House, MessageCircle, Clock, ChartArea, Users } from "lucide-react";
import { Link, usePathname } from "@/i18n/navigation";

interface SidebarProps {
  isOpen: boolean;   // for mobile toggle
  isMini: boolean;   // mini mode for large screens
  onToggle: () => void;
}

const Sidebar: React.FC<SidebarProps> = ({ isOpen, isMini, onToggle }) => {
  const pathname = usePathname();
  const [width, setWidth] = useState(256);
  const [isLargeScreen, setIsLargeScreen] = useState(true);

  const MINI_WIDTH = 80;

  // Update screen size and width
  useEffect(() => {
    const handleResize = () => {
      const large = window.innerWidth >= 1024;
      setIsLargeScreen(large);
      setWidth(large ? (isMini ? MINI_WIDTH : 256) : 256);
    };
    handleResize();
    window.addEventListener("resize", handleResize);
    return () => window.removeEventListener("resize", handleResize);
  }, [isMini]);

  useEffect(() => {
    setWidth(isLargeScreen ? (isMini ? MINI_WIDTH : 256) : 256);
  }, [isMini, isLargeScreen]);

  // Button classes with proper light/dark contrast
  const getNavButtonClasses = (path: string) =>
    `flex items-center gap-3 px-3 py-2 rounded-lg transition-colors
      ${
        pathname?.endsWith(path)
          ? "bg-[#0D2A4B] dark:bg-[#10B981] text-white"
          : "text-gray-800 dark:text-gray-300 hover:bg-[#0D2A4B] dark:hover:bg-[#10B981] hover:text-white"
      }`;

  return (
    <div
      className={`fixed top-0 left-0 h-screen bg-[#f6f6f6] dark:bg-gray-800 shadow-2xl border-r-2 border-gray-200 dark:border-gray-700 z-30 transform transition-all duration-300`}
      style={{
        width,
        transform:
          !isLargeScreen && !isOpen ? "translateX(-100%)" : "translateX(0)",
      }}
    >
      {/* Toggle button */}
      <div className="p-4 border-b border-gray-200 dark:border-gray-700 flex items-center justify-between z-40">
        <button
          onClick={onToggle}
          className="px-3 py-2 rounded-lg text-gray-800 dark:text-gray-300 hover:bg-[#143d6d] dark:hover:bg-[#2fc593] hover:text-white flex items-center gap-2 transition-colors"
        >
          {isMini || (!isOpen && !isLargeScreen) ? (
            // Burger icon
            <svg
              width="24"
              height="24"
              viewBox="0 0 24 24"
              stroke="currentColor"
              strokeWidth="2"
              strokeLinecap="round"
            >
              <line x1="3" y1="6" x2="21" y2="6" />
              <line x1="3" y1="12" x2="21" y2="12" />
              <line x1="3" y1="18" x2="21" y2="18" />
            </svg>
          ) : (
            // X icon
            <svg
              width="24"
              height="24"
              viewBox="0 0 24 24"
              stroke="currentColor"
              strokeWidth="2"
              strokeLinecap="round"
            >
              <line x1="6" y1="6" x2="18" y2="18" />
              <line x1="6" y1="18" x2="18" y2="6" />
            </svg>
          )}
        </button>
      </div>

      {/* Navigation */}
      <nav className="flex-1 overflow-y-auto p-2 mt-2">
        <Link href="/dashboard">
          <button className={getNavButtonClasses("/dashboard")}>
            <House className="w-4 h-4" />
            {!isMini && <span className="text-gray-800 dark:text-gray-200 text-lg">Home</span>}
          </button>
        </Link>
        <Link href="/vent">
          <button className={getNavButtonClasses("/vent")}>
            <MessageCircle className="w-4 h-4" />
            {!isMini && <span className="text-gray-800 dark:text-gray-200 text-lg">Vent</span>}
          </button>
        </Link>
        <Link href="/journal">
          <button className={getNavButtonClasses("/journal")}>
            <Clock className="w-4 h-4" />
            {!isMini && <span className="text-gray-800 dark:text-gray-200 text-lg">Journal</span>}
          </button>
        </Link>
        <Link href="/progress">
          <button className={getNavButtonClasses("/progress")}>
            <ChartArea className="w-4 h-4" />
            {!isMini && <span className="text-gray-800 dark:text-gray-200 text-lg">Progress</span>}
          </button>
        </Link>
        <Link href="/settings">
          <button className={getNavButtonClasses("/settings")}>
            <Users className="w-4 h-4" />
            {!isMini && <span className="text-gray-800 dark:text-gray-200 text-lg">Settings</span>}
          </button>
        </Link>
      </nav>
    </div>
  );
};

export default Sidebar;
