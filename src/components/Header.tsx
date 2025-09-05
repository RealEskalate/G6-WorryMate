"use client";

import { useTranslations, useLocale } from "next-intl";
import { useRouter, usePathname } from "next/navigation";
import { Globe } from "lucide-react";
import Link from "next/link";

export default function Header() {
  const t = useTranslations("Header");
  const locale = useLocale();
  const router = useRouter();
  const pathname = usePathname();

  const changeLanguage = (newLocale: string) => {
    const pathnameWithoutLocale = pathname.replace(`/${locale}`, "") || "/";
    const newPath = `/${newLocale}${pathnameWithoutLocale}`;
    router.push(newPath);
  };

  return (
    <header className="bg-[#0D2A4B] text-white shadow-md">
      <div className="max-w-6xl mx-auto flex items-center justify-between px-6 py-4">
        {/* Logo / Title */}
        <Link href={`/${locale}`} className="text-xl font-bold">
          Worrymate
        </Link>

        {/* Navigation */}
        {/* <nav className="hidden md:flex">
          <Link href={`/${locale}/settings`} className="hover:underline">
            {t("settings")}
          </Link>
        </nav> */}

        {/* Language Switcher */}
        <div className="flex items-center gap-2">
          <Globe className="w-5 h-5" />
          <select
            value={locale}
            onChange={(e) => changeLanguage(e.target.value)}
            className="bg-transparent text-white border border-white rounded-md px-2 py-1 cursor-pointer"
          >
            <option value="en" className="text-blue-900">English</option>
            <option value="am" className="text-blue-900">አማርኛ</option>
          </select>
        </div>
      </div>
    </header>
  );
}
