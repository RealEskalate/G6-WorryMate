'use client'
import React, { useEffect, useState } from 'react'
import { useRouter } from 'next/navigation'
import { db, JournalEntry } from '@/app/lib/db';
import { format } from 'date-fns'
import { useTranslations } from 'next-intl'

function getRelativeLabel(dateString: string) {
  const d = new Date(dateString)
  const today = new Date()
  const dayDiff = Math.floor((today.setHours(0,0,0,0) as unknown as number) - (new Date(d).setHours(0,0,0,0) as unknown as number)) / (1000 * 60 * 60 * 24)
  if (dayDiff === 0) return 'Today'
  if (dayDiff === 1) return 'Yesterday'
  return format(d, 'PP')
}

function RecentEntries() {
  const router = useRouter();
  const t = useTranslations('RecentEntries'); 
  const [entries, setEntries] = useState<JournalEntry[]>([]);

  useEffect(() => {
    const fetchEntries = async () => {
      const all = await db.journals.toArray();
      all.reverse()
      setEntries(all);
    };
    fetchEntries();
  }, []);

  return (
    <div className='bg-white/80  dark:bg-[#092B47] rounded-2xl border border-gray-200 dark:border-gray-700'>
      <div className="flex items-center justify-between px-6 py-4 border-b border-gray-200 dark:border-gray-700">
        <h2 className="text-xl font-semibold text-[#0D2A4B] dark:text-[#10B981]">{t('recentEntries')}</h2>
        <button
          onClick={() => router.push('/journal')}
          className="inline-flex items-center gap-2 rounded-full bg-emerald-600 hover:bg-emerald-700 text-white text-sm font-medium px-4 py-2 transition-colors"
        >
          <span className="text-base leading-none">+</span>
          {t('newEntry')}
        </button>
      </div>

      <div className="max-h-[calc(100vh-670px)] overflow-y-auto divide-y divide-gray-200 dark:divide-gray-700">
        {entries.length === 0 ? (
          <div className="px-6 py-8">
            <p className="text-[#0D2A4B] dark:text-gray-300 font-['Inter','Noto_Sans_Ethiopic'] text-[16px] leading-relaxed">
              {t('noEntriesYet')}
            </p>
          </div>
        ) : (
          entries.map((entry) => (
            <button
              key={entry.id}
              onClick={() => router.push(`/journal/${entry.id}`)}
              className="w-full text-left px-6 py-5 hover:bg-gray-50 dark:hover:bg-gray-700/40 transition-colors"
              aria-label={`${t('viewEntry')}: ${entry.title}`}
            >
              <div className="flex items-center gap-2 text-sm text-gray-500 dark:text-gray-300 mb-2">
                <span className="inline-block w-2 h-2 rounded-full bg-emerald-500" />
                <span>{getRelativeLabel(entry.date)}</span>
              </div>
              <h4 className="text-[17px] md:text-[18px] font-medium text-gray-900 dark:text-gray-100 mb-1">
                {entry.title}
              </h4>
      
            </button>
          ))
        )}

      </div>
    </div>
  )
}

export default RecentEntries
