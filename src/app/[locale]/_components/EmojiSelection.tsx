'use client';
import React, { useState, useEffect } from 'react';
import { useRouter } from 'next/navigation';
import { db } from '@/app/lib/db';
import { emoji } from '@/app/lib/emoji';
import { useTranslations } from 'next-intl';

const EmojiSelection: React.FC = () => {
  const [selectedEmoji, setSelectedEmoji] = useState<string | null>(null);
  const router = useRouter();
  const t = useTranslations('EmojiSelection'); // Namespace from your JSON

  useEffect(() => {
    async function getEmoji() {
      const today = new Date().toISOString().split('T')[0];
      const entry = await db.dailyemoji.get(today);
      if (entry) {
        setSelectedEmoji(entry.emoji);
      }
    }
    getEmoji();
  }, []);

  const handleSelect = async (em: string) => {
    setSelectedEmoji(em);

    const today = new Date().toISOString().split('T')[0];
    const existing = await db.dailyemoji.get(today);

    if (existing) {
      await db.dailyemoji.update(today, { emoji: em });
    } else {
      await db.dailyemoji.add({ date: today, emoji: em });
    }

    router.push('/dashboard');
  };

  return (
    <div className="p-4 text-[#0D2A4B] dark:text-white max-w-4xl mx-auto">
      <h1 className="text-2xl sm:text-3xl font-bold mb-4 text-center sm:text-left">
        {t('selectMood')}
      </h1>

      <div className="grid grid-cols-4 sm:grid-cols-6 md:grid-cols-8 gap-4 justify-items-center">
        {emoji.map((item, i) => (
          <div key={i} className="flex flex-col items-center">
            <div
              onClick={() => handleSelect(item.emoji)}
              className={`flex items-center justify-center cursor-pointer w-12 sm:w-14 h-12 sm:h-14 text-xl sm:text-2xl m-1 sm:m-2 rounded-full transition 
                ${selectedEmoji === item.emoji 
                  ? 'bg-[#0D2A4B] dark:bg-[#10B981] text-white scale-110' 
                  : 'bg-[#F7F9FB] hover:bg-gray-100 dark:bg-gray-700 dark:hover:bg-gray-600'}
              `}
            >
              {item.emoji}
            </div>
            <div className="text-xs sm:text-sm mt-1 text-center">
              {t(item.description)} 
            </div>
          </div>
        ))}
      </div>
    </div>
  );
};

export default EmojiSelection;
