'use client';
import React, { useState, useEffect } from 'react';
import Image from 'next/image';
import image from '../../../../public/Chatbot.png';
import EmojiSelection from './EmojiSelection';
import { useTranslations } from 'next-intl';

type Quote = {
  text: string;
  author: string | null;
};

const motivationalKeywords = [
  'success',
  'inspiration',
  'motivation',
  'hope',
  'dream',
  'achieve',
  'believe',
  'courage',
  'perseverance',
  'strength',
  'positive',
  'goal',
  'aspire',
  'uplift',
  'determination',
];

const HowFeel: React.FC = () => {
  const [show, setShow] = useState(false);
  const [quote, setQuote] = useState<Quote>();
  const t = useTranslations('HowFeel'); // namespace in JSON

  const fetchQuote = async () => {
    try {
      const res = await fetch('https://type.fit/api/quotes', { cache: 'no-store' });
      if (!res.ok) throw new Error(`HTTP error! status: ${res.status}`);

      const data: Quote[] = await res.json();
      const motivationalQuotes = data.filter((q) =>
        q.text.length <= 100 &&
        motivationalKeywords.some((keyword) => q.text.toLowerCase().includes(keyword))
      );

      const randomQuote =
        motivationalQuotes[Math.floor(Math.random() * motivationalQuotes.length)] ||
        data.find((q) => q.text.length <= 100) ||
        data[0];

      setQuote(randomQuote);
    } catch (err) {
      console.error(err);
    }
  };

  useEffect(() => {
    fetchQuote();
  }, []);

  const timecheck = () => {
    const hour = new Date().getHours();
    if (hour >= 5 && hour < 12) return t('morning'); // "Good Morning 🌅"
    else if (hour >= 12 && hour < 17) return t('afternoon'); // "Good Afternoon 🌞"
    else if (hour >= 17 && hour < 21) return t('evening'); // "Good Evening 🌇"
    else return t('night'); // "Burning the midnight oil? 🌃"
  };

  return (
    <div className="w-[90%] relative flex flex-col md:flex-row items-start justify-between bg-[#F7F9FB] dark:bg-[#092B47] rounded-xl shadow-md max-w-5xl mx-auto overflow-hidden p-6">
      
      {/* Text & Emoji Section */}
      <div className="flex flex-col gap-4 w-full md:w-1/2 z-10 text-[#0D2A4B] dark:text-white">
        <h1 className="text-xl sm:text-2xl md:text-3xl font-semibold">{quote?.text}</h1>
        <h2 className="text-lg sm:text-xl md:text-2xl font-semibold dark:text-[#10B981]">
          {`${timecheck()}, ${t('howDoYouFeel')}?`}
        </h2>
        <p className="text-base opacity-90">{t('markMood')}</p>

        <button
          onClick={() => setShow(!show)}
          className="bg-[#0D2A4B] dark:bg-[#10B981] text-white px-4 py-2 rounded-md font-medium hover:bg-[#0c2847] transition w-max"
        >
          {show ? t('hide') : t('markNow')}
        </button>

        {show && (
          <div className="mt-4">
            <EmojiSelection />
          </div>
        )}
      </div>

      {/* Image Section */}
     <div className="relative w-full md:w-1/2 h-64 md:min-h-[300px] mt-4 md:mt-0">
  <Image
    src={image}
    alt={t('chatbotIllustration')}
    fill
    className="object-cover opacity-80 rounded-lg"
    priority
  />
</div>

    </div>
  );
};

export default HowFeel;
