"use client";
import { useTranslations } from 'next-intl';
import { useLocale } from 'next-intl';
import { usePathname, useRouter } from 'next/navigation';
import { ArrowLeft, Globe, Plus, Minus, Trash2 } from 'lucide-react';

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
    <div className="min-h-screen bg-gray-50">
      {/* Header */}
      <div className="bg-[#0D2A4B] text-white p-6 shadow-lg">
        <div className="max-w-4xl mx-auto flex items-center">
          <button 
            onClick={() => router.push(`/${locale}`)}
            className="mr-4 w-10 h-10 rounded-full bg-white/20 flex items-center justify-center hover:bg-white/30 transition-colors"
          >
            <ArrowLeft className="w-5 h-5" />
          </button>
          <div>
            <h1 className="text-2xl font-bold">Worrymate</h1>
            <p className="text-sm opacity-90">Your AI worry buddy</p>
          </div>
        </div>
      </div>

      {/* Main Content */}
      <div className="max-w-4xl mx-auto p-6">
        <h2 className="text-3xl font-bold text-[#0D2A4B] mb-8 text-center">{t('title')}</h2>

        <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
          {/* Language and Accessibility Section */}
          <div className="bg-white rounded-lg shadow-md overflow-hidden">
            <div className="bg-[#0D2A4B] text-white p-4 flex items-center">
              <Globe className="w-5 h-5 mr-3" />
              <span className="font-medium text-lg">{t('header')}</span>
            </div>
            <div className="p-6 space-y-6">
              {/* Language Selection */}
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-3">{t('language')}</label>
                <div className="grid grid-cols-2 gap-3">
                  <button
                    onClick={() => changeLanguage('en')}
                    className={`p-4 rounded-lg text-left transition-all duration-200 ${
                      locale === 'en' 
                        ? 'bg-[#0D2A4B] text-white shadow-md' 
                        : 'bg-gray-50 border-2 border-gray-200 text-gray-700 hover:border-[#0D2A4B] hover:bg-blue-50'
                    }`}
                  >
                    <div className="text-lg font-semibold">English</div>
                    <div className="text-sm opacity-75">En</div>
                  </button>
                  <button
                    onClick={() => changeLanguage('am')}
                    className={`p-4 rounded-lg text-left transition-all duration-200 ${
                      locale === 'am' 
                        ? 'bg-[#0D2A4B] text-white shadow-md' 
                        : 'bg-gray-50 border-2 border-gray-200 text-gray-700 hover:border-[#0D2A4B] hover:bg-blue-50'
                    }`}
                  >
                    <div className="text-lg font-semibold">አማርኛ</div>
                    <div className="text-sm opacity-75">Am</div>
                  </button>
                </div>
              </div>

            </div>
          </div>

          {/* Privacy and Security Section */}
          <div className="bg-white rounded-lg shadow-md overflow-hidden">
            <div className="bg-[#0D2A4B] text-white p-4">
              <span className="font-medium text-lg">{t('privacy')}</span>
            </div>
            <div className="p-6 space-y-6">
              <div>
                <h3 className="font-semibold text-gray-900 text-lg mb-2">{t('saveChatHistory')}</h3>
                <p className="text-sm text-gray-600 mb-4">{t('saveChatDescription')}</p>
                <div className="flex items-center justify-between">
                  <span className="text-sm font-medium text-gray-700">{t('enableChat')}</span>
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
        <div className="mt-6 bg-white rounded-lg shadow-md overflow-hidden">
          <div className="bg-[#0D2A4B] text-white p-4">
            <span className="font-medium text-lg">{t('about')}</span>
          </div>
          <div className="p-6">
            <div className="flex items-center justify-between">
              <div>
                <h3 className="font-semibold text-gray-900 text-lg">{t('appInfo')}</h3>
                <p className="text-sm text-gray-600 mt-1">{t('appVersion')}</p>
              </div>
              <div className="flex gap-3">
                <span className="bg-gray-100 text-gray-700 px-4 py-2 rounded-full text-sm font-medium">
                  {t('versionTag')}
                </span>
                <span className="bg-blue-100 text-[#0D2A4B] px-4 py-2 rounded-full text-sm font-medium">
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
