'use client';
import React, { useState } from 'react';
import Image from 'next/image';
import image from '../../../../public/Chatbot.png';
import EmojiSelection from './EmojiSelection';
import { useTranslations } from 'next-intl';

const HowFeel: React.FC = () => {
  const [show, setShow] = useState(false);
  const t = useTranslations('HowFeel');

  const timecheck = () => {
    const hour = new Date().getHours();
    if (hour >= 5 && hour < 12) return t('morning');
    else if (hour >= 12 && hour < 17) return t('afternoon');
    else if (hour >= 17 && hour < 21) return t('evening');
    else return t('night');
  };

  return (
    <div className="w-full bg-[#F7F9FB] dark:bg-[#092B47] rounded-lg shadow-md p-2 sm:p-4">
      <div className="flex flex-col sm:flex-row items-start justify-between gap-4 w-full max-w-full">
        {/* Left Section */}
        <div className="flex-1 min-w-0 text-[#0D2A4B] dark:text-white z-10">
          <h2 className="text-sm sm:text-lg md:text-xl font-semibold dark:text-[#10B981] mt-2">
            {`${timecheck()}, ${t('howDoYouFeel')}?`}
          </h2>
          <p className="text-xs sm:text-sm opacity-90 mt-1">{t('markMood')}</p>
          <button
            onClick={() => setShow(!show)}
            className="bg-[#0D2A4B] dark:bg-[#10B981] text-white px-2 sm:px-4 py-1 sm:py-2 rounded-md font-medium hover:bg-[#0c2847] transition w-full sm:w-max mt-2"
          >
            {show ? t('hide') : t('markNow')}
          </button>
          {show && (
            <div className="mt-2">
              <EmojiSelection />
            </div>
          )}
        </div>

        {/* Right Section (Image) */}
        <div className="w-full sm:w-1/3 relative h-32 sm:h-48 md:h-64 hidden sm:block">
          <Image
            src={image}
            alt={t('chatbotIllustration')}
            fill
            sizes="(max-width: 640px) 100vw, 33vw"
            className="object-contain opacity-80 rounded-lg"
            priority
          />
        </div>
      </div>
    </div>
  );
};

export default HowFeel;
