'use client'
import React, { useState, useEffect } from 'react';
import { emoji } from '../lib/emoji';
import { db } from '../lib/db';

function EmojiSelection() {
  const [selectedEmoji, setSelectedEmoji] = useState<string | null>(null);
  


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

  const handleSelect = async (em: string, description?: string) => {
    setSelectedEmoji(em);
  

    const today = new Date().toISOString().split('T')[0];
    const existing = await db.dailyemoji.get(today);

    if (existing) {
      await db.dailyemoji.update(today, { emoji: em });
    } else {
      await db.dailyemoji.add({ date: today, emoji: em });
    }
  };

  return (
    <div className="p-4 text-[#0D2A4B]">
      <h1 className="text-2xl font-bold mb-4">Select your mood</h1>
      <div className="grid grid-cols-6 sm:grid-cols-8 gap-4">
        {emoji.map((item, i) => (
          <div key={i} className="flex flex-col items-center">
            <div
              onClick={() => handleSelect(item.emoji, item.description)}
              className={`flex items-center justify-center cursor-pointer w-14 h-14 text-2xl m-2 rounded-full transition 
                ${selectedEmoji === item.emoji ? 'bg-[#0D2A4B] text-white scale-110' : 'bg-[#F7F9FB] hover:bg-gray-100'}
              `}
            >
              {item.emoji}
            </div>
            <div className="text-sm mt-1 text-center">{item.description}</div>
          </div>
        ))}
      </div>

    </div>
  );
}

export default EmojiSelection;
