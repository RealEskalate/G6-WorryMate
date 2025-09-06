'use client';

import {useLocale} from 'next-intl';
import {usePathname, useRouter} from 'next/navigation';

export default function LanguageSelect() {
  const locale = useLocale();
  const router = useRouter();
  const pathname = usePathname();

  const changeLanguage = (newLocale: string) => {
    // Remove the current locale from the pathname
    const pathnameWithoutLocale = pathname.replace(`/${locale}`, '') || '/';
    // Build URL with the new locale
    const newPath = `/${newLocale}${pathnameWithoutLocale}`;
    router.push(newPath);
  };

  return (
    <select 
      value={locale} 
      onChange={(e) => changeLanguage(e.target.value)}
      className="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
    >
      <option value="en">English</option>
      <option value="am">አማርኛ (Amharic)</option>
    </select>
  );
}