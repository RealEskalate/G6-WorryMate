'use client';

import {useLocale} from 'next-intl';
import {usePathname, useRouter} from 'next-intl/client';

export default function LanguageSelect() {
  const router = useRouter();
  const pathname = usePathname(); // current path without locale prefix
  const currentLocale = useLocale();

  function onChange(e: React.ChangeEvent<HTMLSelectElement>) {
    const nextLocale = e.target.value;
    // Swap locale on the current path (no full reload)
    router.replace(pathname, {locale: nextLocale});
    // next-intl also maintains a cookie so refreshes stick to the chosen locale
  }

  return (
    <select
      defaultValue={currentLocale}
      onChange={onChange}
      className="border rounded-lg p-2"
      aria-label="Change language"
    >
      <option value="en">English</option>
      <option value="am">አማርኛ</option>
    </select>
  );
}
