"use client";
import React, { useState, useCallback, useRef, useEffect } from 'react';
import {

  Clock,
  Users,
  ChevronDown,
  ChevronRight,
  Star,
  MoreHorizontal,
  ChartArea,
  MessageCircle,
  House
} from 'lucide-react';
import { Link, usePathname } from "@/i18n/navigation";

interface SidebarProps {
  isCollapsed: boolean;
  onToggle: () => void;
}

const Sidebar: React.FC<SidebarProps> = ({ isCollapsed, onToggle }) => {
  const pathname = usePathname();
  // Width state (px) for small screens (below lg). Default roughly Tailwind w-64 (256px)
  const [width, setWidth] = useState<number>(256);
  const resizingRef = useRef(false);
  const startXRef = useRef(0);
  const startWidthRef = useRef(256);

  const MIN_WIDTH = 180;
  const MAX_WIDTH = 360;

  const onPointerMove = useCallback((e: PointerEvent) => {
    if (!resizingRef.current) return;
    const delta = e.clientX - startXRef.current;
    let next = startWidthRef.current + delta;
    if (next < MIN_WIDTH) next = MIN_WIDTH;
    if (next > MAX_WIDTH) next = MAX_WIDTH;
    setWidth(next);
  }, []);

  const stopResizing = useCallback(() => {
    if (resizingRef.current) {
      resizingRef.current = false;
      document.body.classList.remove("select-none", "cursor-col-resize");
    }
    window.removeEventListener('pointermove', onPointerMove);
    window.removeEventListener('pointerup', stopResizing);
  }, [onPointerMove]);

  const startResizing = useCallback((e: React.PointerEvent) => {
    if (isCollapsed) return; // don't resize when collapsed
    // Only enable on small screens (lg breakpoint ~1024px)
    if (window.innerWidth >= 1024) return;
    resizingRef.current = true;
    startXRef.current = e.clientX;
    startWidthRef.current = width;
    document.body.classList.add("select-none", "cursor-col-resize");
    window.addEventListener('pointermove', onPointerMove);
    window.addEventListener('pointerup', stopResizing);
  }, [isCollapsed, width, onPointerMove, stopResizing]);

  useEffect(() => () => stopResizing(), [stopResizing]);
  const [expandedSections, setExpandedSections] = useState<
    Record<string, boolean>
  >({
    favorites: false,
    favoriteChats: false,
    recents: true,
  });

  const isActive = (path: string) => {
    return typeof pathname === "string" && pathname.endsWith(path);
  };

  const getNavButtonClasses = (path: string) => {
    const baseClasses =
      "w-full flex items-center gap-3 px-3 py-2 text-[#2a4461] dark:text-gray-300 hover:bg-[#0D2A4B] dark:hover:bg-[#10B981] hover:text-white hover:cursor-pointer rounded-lg transition-colors";
    const activeClasses = isActive(path)
      ? "bg-[#0D2A4B] dark:bg-[#10B981] text-white"
      : "";
    return `${baseClasses} ${activeClasses}`;
  };

  const toggleSection = (section: string) => {
    setExpandedSections((prev) => ({
      ...prev,
      [section]: !prev[section],
    }));
  };

  return (
    <div
      className={`relative bg-[#f6f6f6] dark:bg-gray-800 shadow-2xl text-blue h-screen flex flex-col border-2 border-gray-200 dark:border-gray-700 transition-[width] duration-200 overflow-hidden ${isCollapsed ? '' : ''}`}
      style={{ width: isCollapsed ? 64 : width }}
    >
      {/* Resize Handle (only small screens) */}
      {!isCollapsed && (
        <div
          role="separator"
          aria-orientation="vertical"
          aria-label="Resize sidebar"
          onPointerDown={startResizing}
          className="absolute top-0 right-0 h-full w-2 lg:hidden cursor-col-resize group z-20"
        >
          <div className="mx-auto h-full w-1 rounded bg-transparent group-hover:bg-green-500/60 transition-colors" />
        </div>
      )}
      {/* Sidebar Toggle Button */}
     {/* Sidebar Toggle Button */}
<div className="p-4 border-b border-gray-200 dark:border-gray-700 flex items-center justify-between">
  <button
    className="text-[#2a4461] dark:text-gray-300 px-3 py-2 rounded-lg flex items-center gap-2 transition-colors hover:bg-[#143d6d] dark:hover:bg-[#2fc593] hover:text-white"
    onClick={typeof onToggle === "function" ? onToggle : undefined}
    aria-label="Toggle Sidebar"
  >
    {isCollapsed ? (
  
      <svg width="24" height="24" viewBox="0 0 24 24" stroke="currentColor" strokeWidth="2" strokeLinecap="round">
        <line x1="4" y1="6" x2="20" y2="6" />
        <line x1="4" y1="12" x2="20" y2="12" />
        <line x1="4" y1="18" x2="20" y2="18" />
      </svg>
    ) : (
    
      <svg width="24" height="24" viewBox="0 0 24 24" stroke="currentColor" strokeWidth="2" strokeLinecap="round">
        <line x1="6" y1="6" x2="18" y2="18" />
        <line x1="6" y1="18" x2="18" y2="6" />
      </svg>
    )}
  </button>
</div>


      {/* Navigation */}
      <div className="flex-1 overflow-y-auto">
        <nav className="p-2">
          <Link href="/dashboard">
            <button className={getNavButtonClasses("/dashboard")}>
              <House className="w-4 h-4" />
              {!isCollapsed && <span className="text-lg">Home</span>}
            </button>
          </Link>
          <Link href="/vent">
            <button className={getNavButtonClasses("/vent")}>
              <MessageCircle className="w-4 h-4" />
              {!isCollapsed && <span className="text-lg">Vent</span>}
            </button>
          </Link>
          <Link href="/journal">
            <button className={getNavButtonClasses("/journal")}>
              <Clock className="w-4 h-4" />
              {!isCollapsed && <span className="text-lg">Journal</span>}
            </button>
          </Link>
          <Link href="/progress">
            <button className={getNavButtonClasses("/progress")}>
              <ChartArea className="w-4 h-4" />
              {!isCollapsed && <span className="text-lg">Progress</span>}
            </button>
          </Link>
          <Link href="/settings">
            <button className={getNavButtonClasses("/settings")}>
              <Users className="w-4 h-4" />
              {!isCollapsed && <span className="text-lg">Settings</span>}
            </button>
          </Link>
        </nav>

      </div>

      {/* New Feature Banner */}
      {/* {!isCollapsed && (
                <div className="p-4 border-t">
                    <div className="bg-gradient-to-r from-blue-600/20 to-purple-600/20 border border-blue-500/30 rounded-lg p-3 relative">
                        <button className="absolute top-2 right-2 text-[#2a4461] hover:bg-sidebar-accent hover:text-white" >
                            <span className="text-xs">×</span>
                        </button>
                        <div className="flex items-start gap-2">
                            <Star className="w-4 h-4 text-blue-400 mt-0.5" />
                            <div>
                                <p className="text-xs font-medium text-white">New Feature</p>
                                <p className="text-xs text-[#2a4461] mt-1">
                                    v0 will now sync across tabs and browsers while messages
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
            )} */}
    </div>
  );
};

export default Sidebar;