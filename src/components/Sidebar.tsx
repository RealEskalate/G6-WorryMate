import React, { useState } from 'react';
import {

    Clock,
    Users,
    ChevronDown,
    ChevronRight,
    Star,
    MoreHorizontal,
    ChartArea,
    MessageCircle
} from 'lucide-react';
import Link from 'next/link';
import { usePathname } from 'next/navigation';

interface SidebarProps {
    isCollapsed: boolean;
    onToggle: () => void;
}

const Sidebar: React.FC<SidebarProps> = ({ isCollapsed, onToggle }) => {
    const pathname = usePathname();
    const [expandedSections, setExpandedSections] = useState<Record<string, boolean>>({
        favorites: false,
        favoriteChats: false,
        recents: true
    });

    const isActive = (path: string) => {
        return pathname === path;
    };

    const getNavButtonClasses = (path: string) => {
        const baseClasses = "w-full flex items-center gap-3 px-3 py-2 text-[#2a4461] dark:text-gray-300 hover:bg-[#0D2A4B] dark:hover:bg-[#10B981] hover:text-white hover:cursor-pointer rounded-lg transition-colors";
        const activeClasses = isActive(path) ? "bg-[#0D2A4B] dark:bg-[#10B981] text-white" : "";
        return `${baseClasses} ${activeClasses}`;
    };

    const toggleSection = (section: string) => {
        setExpandedSections(prev => ({
            ...prev,
            [section]: !prev[section]
        }));
    };

    return (
        <div className={`bg-[#f6f6f6] dark:bg-gray-800 shadow-2xl text-blue h-screen flex flex-col border-2 border-gray-200 dark:border-gray-700 transition-all duration-300 ${isCollapsed ? 'w-16' : 'w-64'
            }`}>
            {/* Sidebar Toggle Button */}
            <div className="p-4 border-b border-gray-200 dark:border-gray-700 flex items-center justify-between">
                <button
                    className="text-[#2a4461] dark:text-gray-300 px-3 py-2 rounded-lg flex items-center gap-2 transition-colors hover:bg-[#0D2A4B] dark:hover:bg-[#10B981] hover:text-white"
                    onClick={typeof onToggle === 'function' ? onToggle : undefined}
                    aria-label="Toggle Sidebar"
                >
                </button>
            </div>

            {/* Navigation */}
            <div className="flex-1 overflow-y-auto">
                <nav className="p-2">
                    <Link href="/dashboard">
                        <button className={getNavButtonClasses("/dashboard")}>
                            <MessageCircle className="w-4 h-4" />
                            {!isCollapsed && <span className="text-lg">Home</span>}
                        </button>
                    </Link>
                    <Link href="/vent">
                        <button className={getNavButtonClasses("/vent")}>
                            <MessageCircle className="w-4 h-4" />
                            {!isCollapsed && <span className="text-lg">Vent</span>}
                        </button>
                    </Link>

                    {/* Recents */}
                    <Link href="/journal">
                        <button className={getNavButtonClasses("/journal")}>
                            <Clock className="w-4 h-4" />
                            {!isCollapsed && <span className="text-lg">Journal</span>}
                        </button>
                    </Link>

                    {/* Community */}
                    <Link href="/settings">
                        <button className={getNavButtonClasses("/settings")}>
                            <Users className="w-4 h-4" />
                            {!isCollapsed && <span className="text-lg">Settings</span>}
                        </button>
                    </Link>
                </nav>

                {!isCollapsed && (
                    // <>
                    //     {/* Favorite Projects */}
                    <div className="px-2 py-2">
                        <button
                            onClick={() => toggleSection('favorites')}
                            className="w-full flex items-center justify-between px-3 py-2 text-[#2a4461] dark:text-gray-300 hover:bg-[#0D2A4B] dark:hover:bg-[#10B981] hover:text-white text-lg font-medium rounded-lg transition-colors"
                        >
                            <span>Action Items</span>
                            {expandedSections.favorites ? (
                                <ChevronDown className="w-4 h-4" />
                            ) : (
                                <ChevronRight className="w-4 h-4" />
                            )}
                        </button>
                    </div>

                    //     {/* Favorite Chats */}
                    //     <div className="px-2 py-2">
                    //         <button
                    //             onClick={() => toggleSection('favoriteChats')}
                    //             className="w-full flex items-center justify-between px-3 py-2 text-blue hover:bg-[#0D2A4B] hover:text-white text-lg font-medium"
                    //         >
                    //             <span className='text-blue hover:text-white'>Favorite Chats</span>
                    //             {expandedSections.favoriteChats ? (
                    //                 <ChevronDown className="w-4 h-4" />
                    //             ) : (
                    //                 <ChevronRight className="w-4 h-4" />
                    //             )}
                    //         </button>
                    //     </div>

                    //     {/* Recents Section */}
                    //     <div className="px-2 py-2">
                    //         <button
                    //             onClick={() => toggleSection('recents')}
                    //             className="w-full flex items-center justify-between px-3 py-2 text-blue hover:bg-[#0D2A4B] hover:text-white text-lg font-medium"
                    //         >
                    //             <span className='text-blue'>Recents</span>
                    //             {expandedSections.recents ? (
                    //                 <ChevronDown className="w-4 h-4" />
                    //             ) : (
                    //                 <ChevronRight className="w-4 h-4" />
                    //             )}
                    //         </button>

                    //         {expandedSections.recents && (
                    //             <div className="mt-1 space-y-1">
                    //                 {recentProjects.map((project, index) => (
                    //                     <div key={index} className="flex items-center justify-between group">
                    //                         <button className="flex-1 text-left px-3 py-2 text-blue hover:bg-[#0D2A4B] hover:text-white hover: rounded-lg text-lg transition-colors truncate">
                    //                             {project}
                    //                         </button>
                    //                         <button className="opacity-0 group-hover:opacity-100 p-1 rounded transition-opacity">
                    //                             <MoreHorizontal className="w-3 h-3 text-[#2a4461]" />
                    //                         </button>
                    //                     </div>
                    //                 ))}
                    //             </div>
                    //         )}
                    //     </div>
                    // </>
                )}
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