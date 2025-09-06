"use client"
import React, { useState } from 'react'
import { usePathname } from 'next/navigation'
import Sidebar from './Sidebar'

interface LayoutWithSidebarProps {
    children: React.ReactNode
}

const LayoutWithSidebar: React.FC<LayoutWithSidebarProps> = ({ children }) => {
    const [sidebarCollapsed, setSidebarCollapsed] = useState(false)
    const pathname = usePathname()

    const toggleSidebar = () => {
        setSidebarCollapsed(!sidebarCollapsed)
    }

    // Define app pages that should show the sidebar
    const appPages = [
      "/dashboard",
      "/vent",
      "/journal",
      "/settings",
      "/progress",
    ];
    const shouldShowSidebar = appPages.some(page => pathname.includes(page))

    // If it's the homepage, just render children without sidebar
    if (!shouldShowSidebar) {
        return <>{children}</>
    }

    return (
        <div className='h-screen flex flex-row min-h-screen text-[#2a4461] bg-[#ffffff]'>
            {/* Collapse Button - always visible */}
            <button
                onClick={toggleSidebar}
                className="fixed top-4 left-4 z-50 p-2 bg-white rounded-lg shadow-lg border"
            >
                {/* Menu icon can be added here if needed */}
            </button>

            {/* Sidebar */}
            <div className={`${sidebarCollapsed ? 'hidden lg:block' : 'block'} lg:relative lg:items-start`}>
                <Sidebar isCollapsed={sidebarCollapsed} onToggle={toggleSidebar} />
            </div>

            {/* Main Content */}
            <div className='flex flex-col flex-1 relative items-stretch h-screen min-h-0'>
                {children}
            </div>
        </div>
    )
}

export default LayoutWithSidebar
