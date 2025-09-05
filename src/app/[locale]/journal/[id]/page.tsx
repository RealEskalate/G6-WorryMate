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
      <div className="min-h-screen flex items-center justify-center text-gray-900 dark:text-white font-sans text-base bg-gray-50 dark:bg-[#092B47]">
        Loading journal...
      </div>
    );
  }

  return (
    <div className="min-h-screen dark:text-white bg-gray-50 dark:bg-[#092B47] py-8 px-4 sm:px-6 lg:px-8 flex justify-center">
      <div className="w-full max-w-3xl bg-white dark:bg-[#28445C] dark:border-[#10B981] shadow-xl rounded-2xl p-8 sm:p-10 border border-gray-200">
        {/* Date */}
        <p className="text-gray-500 dark:text-gray-300 text-sm mb-4 italic font-sans">
          {new Date(entry.date).toLocaleDateString('en-US', {
            weekday: 'long',
            year: 'numeric',
            month: 'long',
            day: 'numeric',
          })}
        </p>

        {/* Title */}
        <div className="mb-6">
          {isEditingTitle ? (
            <input
              type="text"
              value={title}
              onChange={(e) => setTitle(e.target.value)}
              autoFocus
              placeholder="Enter a title..."
              className="w-full text-3xl sm:text-4xl font-bold text-gray-900 dark:text-white border-b border-gray-300 dark:border-gray-400 bg-transparent focus:outline-none focus:border-gray-900 dark:focus:border-[#10B981] leading-snug"
            />
          ) : (
            <h1
              onDoubleClick={() => setIsEditingTitle(true)}
              className="text-3xl sm:text-4xl font-bold text-gray-900 dark:text-white cursor-pointer hover:text-gray-700 dark:hover:text-[#10B981] leading-snug"
            >
              {title || 'Untitled Journal'}
            </h1>
          )}
        </div>

        {/* Content */}
        <div>
          {isEditingContent ? (
            <textarea
              value={content}
              onChange={(e) => setContent(e.target.value)}
              rows={12}
              autoFocus
              placeholder="Start writing your thoughts..."
              className="w-full text-base sm:text-lg text-gray-900 dark:text-white leading-relaxed bg-transparent border border-gray-300 dark:border-gray-400 rounded-lg p-4 focus:outline-none focus:border-gray-900 dark:focus:border-[#10B981] focus:ring-2 focus:ring-gray-200 dark:focus:ring-[#10B981]/30 transition-shadow"
            />
          ) : (
            <p
              onClick={() => setIsEditingContent(true)}
              className="text-base sm:text-lg text-gray-900 dark:text-white leading-relaxed whitespace-pre-line cursor-pointer hover:bg-gray-100 dark:hover:bg-[#10B981]/20 rounded-lg p-3 transition-colors"
            >
              {content || 'Click here to start writing your thoughts...'}
            </p>
          )}
        </div>

        {/* Buttons */}
        <div className="flex justify-end gap-4 mt-8">
          <button
            onClick={async () => {
              await db.journals.delete(Number(id));
              router.push('/journal');
            }}
            className="bg-red-500 hover:bg-red-600 dark:bg-red-600 dark:hover:bg-red-700 text-white rounded-xl px-6 py-2 shadow transition-colors font-semibold"
          >
            Delete
          </button>

          <button
            onClick={handleUpdate}
            className="bg-green-500 hover:bg-green-600 dark:bg-[#10B981] dark:hover:bg-green-700 text-white rounded-xl px-6 py-2 shadow transition-colors font-semibold"
          >
            Update
          </button>
        </div>
      </div>
    </div>
  );
}

export default Page;
