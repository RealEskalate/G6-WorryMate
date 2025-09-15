'use client'
import React, { useState, useEffect } from "react";
import Sidebar from "./Sidebar";
import { usePathname } from "next/navigation";

const LayoutWithSidebar: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const [sidebarOpen, setSidebarOpen] = useState(false);
  const [sidebarMini, setSidebarMini] = useState(false);
  const [isLargeScreen, setIsLargeScreen] = useState(true);
  const pathname = usePathname();

  useEffect(() => {
    const handleResize = () => {
      const large = window.innerWidth >= 1024;
      setIsLargeScreen(large);
      if (large) setSidebarOpen(true);
    };
    handleResize();
    window.addEventListener("resize", handleResize);
    return () => window.removeEventListener("resize", handleResize);
  }, []);

  const toggleSidebar = () => {
    if (isLargeScreen) {
      setSidebarMini(!sidebarMini);
      setSidebarOpen(true);
    } else {
      setSidebarOpen(!sidebarOpen);
    }
  };

  const appPages = ["/dashboard", "/vent", "/journal", "/settings", "/progress"];
  const shouldShowSidebar = appPages.some((page) => pathname.includes(page));
  if (!shouldShowSidebar) return <>{children}</>;

  return (
    <div className="flex h-screen relative">
      {/* Floating toggle button for small screens */}
      {!isLargeScreen && (
        <button
          onClick={toggleSidebar}
          className="fixed top-4 left-4 z-50 px-3 py-2 rounded-lg bg-[#f6f6f6] dark:bg-gray-800 shadow-lg border border-gray-200 dark:border-gray-700 text-[#2a4461] dark:text-gray-300 hover:bg-[#143d6d] dark:hover:bg-[#2fc593] hover:text-white flex items-center gap-2 transition-colors"
        >
          {sidebarOpen ? (
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
          ) : (
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
          )}
        </button>
      )}

      {/* Overlay for mobile */}
      {!isLargeScreen && sidebarOpen && (
        <div
          className="fixed inset-0 bg-black/30 z-20"
          onClick={() => setSidebarOpen(false)}
        />
      )}

      <Sidebar
        isOpen={sidebarOpen}
        isMini={sidebarMini}
        onToggle={toggleSidebar}
      />

      <main
        className="flex-1 transition-all duration-300 relative z-10"
        style={{
          marginLeft: isLargeScreen ? (sidebarMini ? 80 : 256) : 0,
        }}
      >
        {children}
      </main>
    </div>
  );
};

export default LayoutWithSidebar;
