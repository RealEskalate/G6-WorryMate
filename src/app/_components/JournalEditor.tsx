'use client';
import React, { useEffect, useState } from 'react';
import { useEditor, EditorContent } from '@tiptap/react';
import StarterKit from '@tiptap/starter-kit';
import Bold from '@tiptap/extension-bold';
import Italic from '@tiptap/extension-italic';
import Underline from '@tiptap/extension-underline';
import Strike from '@tiptap/extension-strike';
import Heading from '@tiptap/extension-heading';
import BulletList from '@tiptap/extension-bullet-list';
import OrderedList from '@tiptap/extension-ordered-list';
import Link from '@tiptap/extension-link';
import Placeholder from '@tiptap/extension-placeholder';
import { db, JournalEntry } from '../lib/db';
import { useRouter } from 'next/navigation';

export default function JournalEditor() {
  const [entries, setEntries] = useState<JournalEntry[]>([]);
  const [currentTitle, setCurrentTitle] = useState('');
  const [editorState, setEditorState] = useState(0);
  const router = useRouter();

  const editor = useEditor({
    extensions: [
      StarterKit.configure({ heading: false }),
      Bold,
      Italic,
      Underline,
      Strike,
      Heading.configure({ levels: [1, 2, 3] }),
      BulletList,
      OrderedList,
      Link,
      Placeholder.configure({ placeholder: 'Write your thoughts here...' }),
    ],
    content: '',
    immediatelyRender: false,
  });

  
  useEffect(() => {
    const fetchEntries = async () => {
      const all = await db.journals.toArray();
      setEntries(all);
    };
    fetchEntries();
  }, []);

  
  useEffect(() => {
    if (!editor) return;

    const rerender = () => setEditorState((prev) => prev + 1);
    editor.on('selectionUpdate', rerender);
    editor.on('update', rerender);

    return () => {
      editor.off('selectionUpdate', rerender);
      editor.off('update', rerender);
    };
  }, [editor]);

  // Save journal entry
  const saveEntry = async () => {
    if (!editor) return;
    const content = editor.getText();
    const entry: JournalEntry = {
      title: currentTitle || new Date().toLocaleString(),
      content,
      date: new Date().toISOString(),
    };
    await db.journals.add(entry);
    setCurrentTitle('');
    editor.commands.clearContent();
    const all = await db.journals.toArray();
    setEntries(all);
  };

  if (!editor) return null;

  return (
    <div className="mx-auto max-w-7xl p-4 sm:p-6 lg:p-8 bg-[#F7F9FB] font-sans">
      <h2 className="mb-6 text-3xl font-bold text-[#0D2A4B] sm:text-4xl">
        My Journal
      </h2>
      <div className="flex flex-col gap-6 lg:flex-row lg:gap-8">
        <div className="w-full rounded-xl bg-white p-6 shadow-md lg:w-3/4">
          <input
            type="text"
            placeholder="Entry Title"
            value={currentTitle}
            onChange={(e) => setCurrentTitle(e.target.value)}
            className="mb-4 w-full rounded-lg border border-gray-300 px-5 py-3 text-[16px] text-[#0D2A4B] focus:border-[#0D2A4B] focus:outline-none focus:ring-2 focus:ring-[#0D2A4B]/20 font-['Inter','Noto_Sans_Ethiopic'] leading-relaxed"
            aria-label="Journal entry title"
          />
          <div className="mb-4 rounded-lg border border-gray-300 bg-white p-5">
            <EditorContent
              editor={editor}
              className="min-h-[300px] text-[16px] text-[#0D2A4B] font-['Inter','Noto_Sans_Ethiopic'] leading-relaxed"
            />
          </div>
          <div className="flex gap-4">
            <button
              type="button"
              onClick={(e) => {
                e.preventDefault();
                editor.chain().focus().unsetAllMarks().clearNodes().run();
              }}
              className="rounded-lg border border-[#EF4444] px-5 py-2.5 text-[#EF4444] font-['Inter','Noto_Sans_Ethiopic'] text-[16px] leading-relaxed transition hover:bg-[#EF4444]/10"
              aria-label="Clear editor content"
            >
              Clear
            </button>
            <button
              type="button"
              onClick={saveEntry}
              className="rounded-lg bg-[#10B981] px-5 py-2.5 text-white font-['Inter','Noto_Sans_Ethiopic'] text-[16px] leading-relaxed transition hover:bg-[#10B981]/80"
              aria-label="Save journal entry"
            >
              Save Entry
            </button>
          </div>
        </div>

        <div className="w-full lg:w-1/2">
          <h3 className="mb-4 text-xl font-semibold text-[#0D2A4B] font-['Inter','Noto_Sans_Ethiopic'] leading-relaxed">
            Recent Entries
          </h3>
          <div className="max-h-[calc(100vh-200px)] overflow-y-auto space-y-3 pr-2">
            {entries.length === 0 ? (
              <p className="text-[#0D2A4B] font-['Inter','Noto_Sans_Ethiopic'] text-[16px] leading-relaxed">
                No entries yet. Start writing!
              </p>
            ) : (
              entries.map((entry) => (
                <button
                  key={entry.id}
                  onClick={() => router.push(`/journal/${entry.id}`)}
                  className="w-full rounded-lg border border-gray-200 bg-white p-4 text-left shadow-sm transition hover:bg-[#F7F9FB] font-['Inter','Noto_Sans_Ethiopic']"
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
    </div>
  );
}