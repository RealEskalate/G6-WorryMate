"use client"

import React from 'react'
import { ModeToggle } from './ModeToggle'
import { useLocale } from 'next-intl'
import { useRouter, usePathname } from 'next/navigation'
import { Button } from '@/components/ui/button'
import { Globe } from 'lucide-react'

interface PageHeaderProps {
    title?: string
    showLanguageToggle?: boolean
}

export function PageHeader({ showLanguageToggle = true }: PageHeaderProps) {
    const locale = useLocale()
    const router = useRouter()
    const pathname = usePathname()

    const toggleLanguage = () => {
        const newLocale = locale === 'en' ? 'am' : 'en'
        const newPath = pathname.replace(`/${locale}`, `/${newLocale}`)
        router.push(newPath)
    }

    return (
        <header className="w-full bg-white dark:bg-gray-900 border-b border-gray-200 dark:border-gray-700 px-4 py-3">
            <div className="flex items-center justify-between max-w-7xl mx-auto">
                {/* Left side - WorryMate branding */}
                <div className="flex items-center gap-3">
                    <h1 className="text-2xl font-bold text-[#0D2A4B] dark:text-[#10B981]">
                        WorryMate
                    </h1>
                    {/* {title && (
                        <>
                            <span className="text-gray-400 dark:text-gray-500">/</span>
                            <span className="text-lg font-medium text-gray-700 dark:text-gray-300">
                                {title}
                            </span>
                        </>
                    )} */}
                </div>

                {/* Right side - Controls */}
                <div className="flex items-center gap-3">
                    {/* Language Toggle */}
                    {showLanguageToggle && (
                        <Button
                            variant="outline"
                            size="sm"
                            onClick={toggleLanguage}
                            className="flex items-center gap-2 text-sm dark:bg-[#10B981] bg-[#0D2A4B] text-white dark:text-[#0D2A4B]"
                        >
                            <Globe className="w-4 h-4" />
                            {locale === 'en' ? 'En' : 'አማ'}
                        </Button>
                    )}

                    {/* Theme Toggle */}
                    <ModeToggle />
                </div>
            </div>
        </header>
    )
}
