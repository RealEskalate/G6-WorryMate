"use client";
import { useTranslations } from 'next-intl';
import { useLocale } from 'next-intl';
import { usePathname, useRouter } from 'next/navigation';
import { Globe, Trash2 } from 'lucide-react';
import { PageHeader } from '@/components/PageHeader';

export default function SettingsPage() {
  const t = useTranslations('Settings');
  const locale = useLocale();
  const router = useRouter();
  const pathname = usePathname();

  const changeLanguage = (newLocale: string) => {
    const pathnameWithoutLocale = pathname.replace(`/${locale}`, '') || '/';
    const newPath = `/${newLocale}${pathnameWithoutLocale}`;
    router.push(newPath);
  };

  return (
    <div className="min-h-screen bg-gray-50 dark:bg-gray-900">
      <PageHeader title="Settings" showLanguageToggle={false} />
      {/* Main Content */}
      <div className="max-w-4xl mx-auto p-6">
        <h2 className="text-3xl font-bold text-[#0D2A4B] dark:text-[#10B981] mb-8 text-center">{t('title')}</h2>

        <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
          {/* Language and Accessibility Section */}
          <div className="bg-white dark:bg-gray-800 rounded-lg shadow-md overflow-hidden">
            <div className="bg-[#0D2A4B] dark:bg-[#10B981] text-white p-4 flex items-center">
              <Globe className="w-5 h-5 mr-3" />
              <span className="font-medium text-lg">{t('header')}</span>
            </div>
            <div className="p-6 space-y-6">
              {/* Language Selection */}
              <div className="w-40 space-y-6">
                <label className="font-semibold text-gray-900 dark:text-gray-100 text-lg mb-2">
                  {t("language")}
                </label>
                <div className="relative">
                  <select
                    value={locale}
                    onChange={(e) => changeLanguage(e.target.value)}
                    className="block w-full rounded-md border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-700 text-gray-900 dark:text-gray-100 py-2 pl-3 pr-10 text-sm focus:border-[#0D2A4B] dark:focus:border-[#10B981] focus:outline-none focus:ring-1 focus:ring-[#0D2A4B] dark:focus:ring-[#10B981]"
                  >
                    <option value="en">English (En)</option>
                    <option value="am">አማርኛ (Am)</option>
                  </select>
                </div>
              </div>


            </div>
          </div>

          {/* Privacy and Security Section */}
          <div className="bg-white dark:bg-gray-800 rounded-lg shadow-md overflow-hidden">
            <div className="bg-[#0D2A4B] dark:bg-[#10B981] text-white p-4">
              <span className="font-medium text-lg">{t('privacy')}</span>
            </div>
            <div className="p-6 space-y-6">
              <div>
                <h3 className="font-semibold text-gray-900 dark:text-gray-100 text-lg mb-2">{t('saveChatHistory')}</h3>
                <p className="text-sm text-gray-600 dark:text-gray-400 mb-4">{t('saveChatDescription')}</p>
                <div className="flex items-center justify-between">
                  <span className="text-sm font-medium text-gray-700 dark:text-gray-300">{t('enableChat')}</span>
                  <div className="relative">
                    <input type="checkbox" className="sr-only" id="save-chat" />
                    <label
                      htmlFor="save-chat"
                      className="block w-14 h-7 bg-gray-300 rounded-full cursor-pointer transition-colors duration-200"
                    >
                      <div className="w-6 h-6 bg-white rounded-full absolute top-0.5 left-0.5 shadow-md transition-transform duration-200"></div>
                    </label>
                  </div>
                </div>
              </div>

              <div className="pt-4 border-t border-gray-200">
                <button className="text-red-600 font-medium flex items-center hover:text-red-700 transition-colors">
                  <Trash2 className="w-5 h-5 mr-2" />
                  <span>{t('deleteChat')}</span>
                </button>
              </div>
            </div>
          </div>
        </div>

        {/* About WorryMate Section */}
        <div className="mt-6 bg-white dark:bg-gray-800 rounded-lg shadow-md overflow-hidden">
          <div className="bg-[#0D2A4B] dark:bg-[#10B981] text-white p-4">
            <span className="font-medium text-lg">{t('about')}</span>
          </div>
          <div className="p-6">
            <div className="flex items-center justify-between">
              <div>
                <h3 className="font-semibold text-gray-900 dark:text-gray-100 text-lg">{t('appInfo')}</h3>
                <p className="text-sm text-gray-600 dark:text-gray-400 mt-1">{t('appVersion')}</p>
              </div>
              <div className="flex gap-3">
                <span className="bg-gray-100 dark:bg-gray-700 text-gray-700 dark:text-gray-300 px-4 py-2 rounded-full text-sm font-medium">
                  {t('versionTag')}
                </span>
                <span className="bg-blue-100 dark:bg-blue-900 text-[#0D2A4B] dark:text-[#10B981] px-4 py-2 rounded-full text-sm font-medium">
                  {t('betaTag')}
                </span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
