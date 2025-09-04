'use client'
import React, { useEffect, useState } from 'react'
import { useRouter } from 'next/navigation'
import { db, JournalEntry } from '@/app/lib/db';
function RecentEntires() {
  const router = useRouter();
  const [entries, setEntries] = useState<JournalEntry[]>([]);
  useEffect(() => {
    const fetchEntries = async () => {
      const all = await db.journals.toArray();
      setEntries(all);
    };
    fetchEntries();
  }, []);
  return (
    <div className='shadow-xl rounded-xl pb-2 mt-8 bg-[#F7F9FB]'>
      <div className="w-full  ">
        <div className='px-10 py-2 rounded-[10px] mb-6 '>
          <h2 className="text-xl self-start font-semibold text-[#0D2A4B]">Recent Entries</h2>
        </div>

        <div className="max-h-[calc(100vh-520px)] overflow-y-auto space-y-3 pr-2">
          {entries.length === 0 ? (
            <p className="text-[#0D2A4B] font-['Inter','Noto_Sans_Ethiopic'] text-[16px] leading-relaxed">
              No entries yet.
            </p>
          ) : (
            entries.map((entry) => (
              <button
                key={entry.id}
                onClick={() => router.push(`/journal/${entry.id}`)}
                className="w-full cursor-pointer rounded-lg border border-gray-200 bg-white p-4 text-left shadow-sm transition hover:bg-[#F7F9FB] font-['Inter','Noto_Sans_Ethiopic']"
                aria-label={`View journal entry: ${entry.title}`}
              >
                <h4 className="font-semibold text-[#0D2A4B] text-[18px] leading-relaxed">
                  {entry.title}
                </h4>
                <p className="text-[14px] text-[#0D2A4B]/70 leading-relaxed">
                  {new Date(entry.date).toLocaleString()}
                </p>
              </button>
            ))
          )}
        </div>
      </div>
    </div>
  )
}

export default RecentEntires
