'use client';
import React, { useState, useEffect } from 'react';
import { useParams, useRouter } from 'next/navigation';
import { db, JournalEntry } from '@/app/lib/db';

function Page() {
  const [entry, setEntry] = useState<JournalEntry>();
  const [isEditingTitle, setIsEditingTitle] = useState(false);
  const [isEditingContent, setIsEditingContent] = useState(false);
  const [title, setTitle] = useState('');
  const [content, setContent] = useState('');

  const router = useRouter();
  const { id } = useParams();

  useEffect(() => {
    const fetchEntry = async () => {
      const data = await db.journals.get(Number(id));
      if (data) {
        setEntry(data);
        setTitle(data.title || '');
        setContent(data.content || '');
      }
    };
    fetchEntry();
  }, [id]);

  const handleUpdate = async () => {
    if (!entry) return;
    const updated = { ...entry, title, content };
    await db.journals.put(updated);
    setEntry(updated);
    setIsEditingTitle(false);
    setIsEditingContent(false);
  };

  if (!entry) {
    return (
      <div className="min-h-screen flex items-center justify-center text-[#0D2A4B] font-['Inter','Noto_Sans_Ethiopic'] text-[16px] leading-relaxed bg-[#F7F9FB]">
        Loading journal...
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-[#F7F9FB] py-12 px-6 flex justify-center">
      <div className="w-full max-w-3xl bg-white shadow-xl rounded-2xl p-10 border border-gray-200">
        <p className="text-[#0D2A4B]/70 text-[14px] mb-4 italic font-['Inter','Noto_Sans_Ethiopic'] leading-relaxed">
          {new Date(entry.date).toLocaleDateString('en-US', {
            weekday: 'long',
            year: 'numeric',
            month: 'long',
            day: 'numeric',
          })}
        </p>

        <div className="mb-6">
          {isEditingTitle ? (
            <input
              type="text"
              value={title}
              onChange={(e) => setTitle(e.target.value)}
              autoFocus
              placeholder="Enter a title..."
              className="w-full text-4xl font-bold text-[#0D2A4B] border-b border-[#0D2A4B]/50 bg-transparent focus:outline-none focus:border-[#0D2A4B] font-['Inter','Noto_Sans_Ethiopic'] leading-relaxed"
            />
          ) : (
            <h1
              onDoubleClick={() => setIsEditingTitle(true)}
              className="text-4xl font-bold text-[#0D2A4B] cursor-pointer hover:text-[#0D2A4B]/80 font-['Inter','Noto_Sans_Ethiopic'] leading-relaxed"
            >
              {title || 'Untitled Journal'}
            </h1>
          )}
        </div>

        <div>
          {isEditingContent ? (
            <textarea
              value={content}
              onChange={(e) => setContent(e.target.value)}
              rows={12}
              autoFocus
              placeholder="Start writing your thoughts..."
              className="w-full text-[16px] text-[#0D2A4B] leading-relaxed bg-transparent border border-[#0D2A4B]/50 rounded-lg p-4 focus:outline-none focus:border-[#0D2A4B] focus:ring-2 focus:ring-[#0D2A4B]/20 font-['Inter','Noto_Sans_Ethiopic'] shadow-inner"
            />
          ) : (
            <p
              onClick={() => setIsEditingContent(true)}
              className="text-[16px] text-[#0D2A4B] leading-relaxed whitespace-pre-line cursor-pointer hover:bg-[#0D2A4B]/5 rounded-lg p-3 font-['Inter','Noto_Sans_Ethiopic']"
            >
              {content || 'Click here to start writing your thoughts...'}
            </p>
          )}
        </div>

        <div className="flex justify-end gap-4 mt-10">
          <button
            onClick={async () => {
              await db.journals.delete(Number(id));
              router.push('/journal');
            }}
            className="bg-[#EF4444] hover:bg-[#EF4444]/80 text-white rounded-xl px-6 py-2 shadow-md transition font-['Inter','Noto_Sans_Ethiopic'] text-[16px] leading-relaxed"
          >
            Delete
          </button>

          <button
            onClick={handleUpdate}
            className="bg-[#10B981] hover:bg-[#10B981]/80 text-white rounded-xl px-6 py-2 shadow-md transition font-['Inter','Noto_Sans_Ethiopic'] text-[16px] leading-relaxed"
          >
            Update
          </button>
        </div>
      </div>
    </div>
  );
}

export default Page;