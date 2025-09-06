'use client';
import React, { useEffect, useState } from 'react';
import { db, JournalEntry } from '@/app/lib/db';
import { useRouter } from 'next/navigation';
import { useTranslations } from 'next-intl';

export default function JournalEditor() {
  const [entries, setEntries] = useState<JournalEntry[]>([]);
  const [currentTitle, setCurrentTitle] = useState('');
  const [content, setContent] = useState('');
  const router = useRouter();
  const t = useTranslations('JournalEditor');

  // Fetch recent entries
  useEffect(() => {
    const fetchEntries = async () => {
      const all = await db.journals.toArray();
      all.reverse();
      setEntries(all);
    };
    fetchEntries();
  }, []);

  // Save journal entry
  const saveEntry = async () => {
    if (!content.trim()) return; // don't save empty
    const entry: JournalEntry = {
      title: currentTitle || new Date().toLocaleString(),
      content,
      date: new Date().toISOString(),
    };
    await db.journals.add(entry);
    setCurrentTitle('');
    setContent('');
    const all = await db.journals.toArray();
    setEntries(all);
  };

  return (
    <div className="mx-auto max-w-7xl p-4 sm:p-6 lg:p-8 bg-white dark:bg-[#092B47] font-sans">
      <h2 className="mb-6 text-3xl font-bold text-[#0D2A4B] dark:text-[#10B981] sm:text-4xl">
        {t('myJournal')}
      </h2>

      <div className="flex flex-col gap-6 lg:flex-row lg:gap-8">
        {/* Editor section */}
        <div className="w-full rounded-xl bg-[#F7F9FB] dark:bg-[#28445C] p-6 shadow-md lg:w-3/4">
          <input
            type="text"
            placeholder={t('entryTitle')}
            value={currentTitle}
            onChange={(e) => setCurrentTitle(e.target.value)}
            className="mb-4 w-full rounded-lg border border-gray-300 dark:border-[#72a795] px-5 py-3 text-[16px] text-[#0D2A4B] dark:text-white focus:border-[#0D2A4B] dark:focus:border-[#10B981] focus:outline-none focus:ring-2 focus:ring-[#0D2A4B]/20 dark:focus:ring-[#10B981]/20 font-['Inter','Noto_Sans_Ethiopic'] leading-relaxed"
            aria-label={t('entryTitle')}
          />

          <textarea
            value={content}
            onChange={(e) => setContent(e.target.value)}
            rows={12}
            autoFocus
            placeholder={t('startWriting')}
            className="w-full text-base sm:text-lg text-gray-900 dark:text-white leading-relaxed bg-transparent border border-gray-300 dark:border-gray-400 rounded-lg p-4 focus:outline-none focus:border-gray-900 dark:focus:border-[#10B981] focus:ring-2 focus:ring-gray-200 dark:focus:ring-[#10B981]/30 transition-shadow"
          />

          <div className="flex justify-center mt-4">
            <button
              type="button"
              onClick={saveEntry}
              className="rounded-lg cursor-pointer dark:bg-[#10B981] bg-[#0D2A4B] px-5 py-2.5 text-white font-['Inter','Noto_Sans_Ethiopic'] text-[16px] leading-relaxed transition hover:bg-[#10B981]/80"
              aria-label={t('saveEntry')}
            >
              {t('saveEntry')}
            </button>
          </div>
        </div>

        {/* Recent entries */}
        <div className="w-full lg:w-1/2">
          <h3 className="mb-4 text-3xl font-semibold dark:text-[#10B981] text-[#0D2A4B] font-['Inter','Noto_Sans_Ethiopic'] leading-relaxed">
            {t('recentEntries')}
          </h3>
          <div className="max-h-[calc(100vh-200px)] overflow-y-auto space-y-3 pr-2 bg-[#F7F9FB] dark:bg-[#28445C] shadow-md">
            {entries.length === 0 ? (
              <p className="text-[#0D2A4B] dark:text-[#10B981] font-['Inter','Noto_Sans_Ethiopic'] text-[16px] leading-relaxed">
                {t('noEntries')}
              </p>
            ) : (
              entries.map((entry) => (
                <button
                  key={entry.id}
                  onClick={() => router.push(`/journal/${entry.id}`)}
                  className="w-full cursor-pointer rounded-lg border dark:border-[#10B981] dark:bg-[#28445C] border-gray-200 bg-[#F7F9FB] p-4 text-left shadow-sm transition hover:bg-[#f7f9f0cd] font-['Inter','Noto_Sans_Ethiopic']"
                  aria-label={`View journal entry: ${entry.title}`}
                >
                  <h4 className="font-semibold text-[#0D2A4B] dark:text-white text-[18px] leading-relaxed">
                    {entry.title}
                  </h4>
                  <p className="text-[14px] text-[#0D2A4B]/70 dark:text-white/70 leading-relaxed">
                    {new Date(entry.date).toLocaleString()}
                  </p>
                </button>
              ))
            )}
          </div>
        </div>
      </div>
    </div>
  );
}
