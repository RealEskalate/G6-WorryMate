'use client'
import React, { useEffect, useState } from "react";
import { useEditor, EditorContent } from "@tiptap/react";
import StarterKit from "@tiptap/starter-kit";
import Bold from "@tiptap/extension-bold";
import Italic from "@tiptap/extension-italic";
import Underline from "@tiptap/extension-underline";
import Strike from "@tiptap/extension-strike";
import Heading from "@tiptap/extension-heading";
import BulletList from "@tiptap/extension-bullet-list";
import OrderedList from "@tiptap/extension-ordered-list";
import Link from "@tiptap/extension-link";
import Placeholder from "@tiptap/extension-placeholder";
import { db, JournalEntry } from "../lib/db";

export default function JournalEditor() {
  const [entries, setEntries] = useState<JournalEntry[]>([]);
  const [currentTitle, setCurrentTitle] = useState("");

  const editor = useEditor({
    extensions: [
      StarterKit,
      Bold,
      Italic,
      Underline,
      Strike,
      Heading.configure({ levels: [1, 2, 3] }),
      BulletList,
      OrderedList,
      Link,
      Placeholder.configure({ placeholder: "Write your thoughts here..." }),
    ],
    content: "",
    editorProps: {},
    immediatelyRender: false,
  });

  useEffect(() => {
    const fetchEntries = async () => {
      const all = await db.journals.toArray();
      setEntries(all);
    };
    fetchEntries();
  }, []);

  const saveEntry = async () => {
    if (!editor) return;
    const content = editor.getHTML();
    const entry: JournalEntry = {
      title: currentTitle || new Date().toLocaleString(),
      content,
      date: new Date().toISOString(),
    };
    await db.journals.add(entry);
    setCurrentTitle("");
    editor.commands.clearContent();
    const all = await db.journals.toArray();
    setEntries(all);
  };

  if (!editor) return null; 

  return (
    <div className="p-4 max-w-3xl mx-auto space-y-4 bg-white ronded shadow-black">
      <h2 className="text-2xl font-bold text-[#132A4F]">My Journal</h2>

      <input
        type="text"
        placeholder="Entry Title"
        value={currentTitle}
        onChange={(e) => setCurrentTitle(e.target.value)}
        className="w-full border-b-[#132A4F] rounded px-3 py-2 text-black shadow-[#132A4F] shadow-md"
      />

     <div className="flex flex-wrap gap-2 border-b p-2 bg-gray-50">
  <button
    onClick={() => editor.chain().focus().toggleBold().run()}
    className={`px-2 py-1 border rounded ${
      editor?.isActive("bold") ? "bg-[#132A4F] text-white" : "bg-white text-[#132A4F]"
    }`}
  >
    B
  </button>

  <button
    onClick={() => editor.chain().focus().toggleItalic().run()}
    className={`px-2 py-1 border rounded ${
      editor?.isActive("italic") ? "bg-[#132A4F] text-white" : "bg-white text-[#132A4F]"
    }`}
  >
    I
  </button>

  <button
    onClick={() => editor.chain().focus().toggleUnderline().run()}
    className={`px-2 py-1 border rounded ${
      editor?.isActive("underline") ? "bg-[#132A4F] text-white" : "bg-white text-[#132A4F]"
    }`}
  >
    U
  </button>

  <button
    onClick={() => editor.chain().focus().toggleStrike().run()}
    className={`px-2 py-1 border rounded ${
      editor?.isActive("strike") ? "bg-[#132A4F] text-white" : "bg-white text-[#132A4F]"
    }`}
  >
    S
  </button>

  <button
    onClick={() => editor.chain().focus().toggleHeading({ level: 1 }).run()}
    className={`px-2 py-1 border rounded ${
      editor?.isActive("heading", { level: 1 }) ? "bg-[#132A4F] text-white" : "bg-white text-[#132A4F]"
    }`}
  >
    H1
  </button>

  <button
    onClick={() => editor.chain().focus().toggleHeading({ level: 2 }).run()}
    className={`px-2 py-1 border rounded ${
      editor?.isActive("heading", { level: 2 }) ? "bg-[#132A4F] text-white" : "bg-white text-[#132A4F]"
    }`}
  >
    H2
  </button>

  <button
    onClick={() => editor.chain().focus().toggleHeading({ level: 3 }).run()}
    className={`px-2 py-1 border rounded ${
      editor?.isActive("heading", { level: 3 }) ? "bg-[#132A4F] text-white" : "bg-white text-[#132A4F]"
    }`}
  >
    H3
  </button>

  <button
    onClick={() => editor.chain().focus().toggleBulletList().run()}
    className={`px-2 py-1 border rounded ${
      editor?.isActive("bulletList") ? "bg-[#132A4F] text-white" : "bg-white text-[#132A4F]"
    }`}
  >
    • List
  </button>

  <button
    onClick={() => editor.chain().focus().toggleOrderedList().run()}
    className={`px-2 py-1 border rounded ${
      editor?.isActive("orderedList") ? "bg-[#132A4F] text-white" : "bg-white text-[#132A4F]"
    }`}
  >
    1. List
  </button>

  <button
    onClick={() => editor.chain().focus().unsetAllMarks().clearNodes().run()}
    className="px-2 py-1 border rounded text-red-500"
  >
    Clear
  </button>
</div>


      
      <div className="border rounded p-2 min-h-[300px] text-black">
        <EditorContent editor={editor} />
      </div>

      <button
        onClick={saveEntry}
        className="px-4 py-2 bg-indigo-600 text-white rounded mt-2"
      >
        Save Entry
      </button>

    
      <div className="space-y-2 mt-6">
        {entries.map((e) => (
          <div key={e.id} className="border rounded p-2 bg-white">
            <h3 className="font-semibold">{e.title}</h3>
            <div dangerouslySetInnerHTML={{ __html: e.content }} />
            <small className="text-gray-400">{new Date(e.date).toLocaleString()}</small>
          </div>
        ))}
      </div>
    </div>
  );
}
