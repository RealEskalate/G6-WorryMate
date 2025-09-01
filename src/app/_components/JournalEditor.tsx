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
  const [editorState, setEditorState] = useState(0);
  const editor = useEditor({
    extensions: [
      StarterKit.configure({
        heading: false, 
      }),
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
  editor.on("selectionUpdate", rerender);
  editor.on("update", rerender);

  return () => {
    editor.off("selectionUpdate", rerender);
    editor.off("update", rerender);
  };
}, [editor]);


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
    <div className="p-6 max-w-3xl mx-auto space-y-6 bg-white rounded-xl shadow-md">
      <h2 className="text-2xl font-bold text-[#132A4F]">My Journal</h2>

      <input
        type="text"
        placeholder="Entry Title"
        value={currentTitle}
        onChange={(e) => setCurrentTitle(e.target.value)}
        className="w-full border rounded px-3 py-2 text-black shadow-sm focus:ring focus:ring-indigo-300 focus:outline-none"
      />

      <div className="flex flex-wrap gap-2 border-b p-2 bg-gray-50 rounded">
        {[
          { action: () => editor.chain().focus().toggleBold().run(), label: "B", active: editor.isActive("bold") },
          { action: () => editor.chain().focus().toggleItalic().run(), label: "I", active: editor.isActive("italic") },
          { action: () => editor.chain().focus().toggleUnderline().run(), label: "U", active: editor.isActive("underline") },
          { action: () => editor.chain().focus().toggleStrike().run(), label: "S", active: editor.isActive("strike") },
          { action: () => editor.chain().focus().toggleHeading({ level: 1 }).run(), label: "H1", active: editor.isActive("heading", { level: 1 }) },
          { action: () => editor.chain().focus().toggleHeading({ level: 2 }).run(), label: "H2", active: editor.isActive("heading", { level: 2 }) },
          { action: () => editor.chain().focus().toggleHeading({ level: 3 }).run(), label: "H3", active: editor.isActive("heading", { level: 3 }) },
          { action: () => editor.chain().focus().toggleBulletList().run(), label: "• List", active: editor.isActive("bulletList") },
          { action: () => editor.chain().focus().toggleOrderedList().run(), label: "1. List", active: editor.isActive("orderedList") },
        ].map((btn, i) => (
         
          <button
            key={i}
            type="button"
            onClick={(e) => {
              e.preventDefault();
              btn.action();
            }}
            className={`px-3 py-1 border rounded transition ${
              btn.active ? "bg-[#132A4F] text-white" : "bg-white text-[#132A4F]"
            }`}
          >
            {btn.label}
          </button>
        ))}

        <button
          type="button"
          onClick={(e) => {
            e.preventDefault();
            editor.chain().focus().unsetAllMarks().clearNodes().run();
          }}
          className="px-3 py-1 border rounded text-red-500 hover:bg-red-50"
        >
          Clear
        </button>
      </div>

      <div className="border rounded p-3 min-h-[300px] text-black">
        <EditorContent editor={editor} />
      </div>

      <button
        type="button"
        onClick={saveEntry}
        className="px-4 py-2 bg-indigo-600 text-white rounded hover:bg-indigo-700 transition"
      >
        Save Entry
      </button>
      <div className="space-y-3 mt-6">
        {entries.map((e) => (
          <div key={e.id} className="border rounded p-3 bg-gray-50 shadow-sm">
            <h3 className="font-semibold">{e.title}</h3>
            <div dangerouslySetInnerHTML={{ __html: e.content }} />
            <small className="text-gray-400">{new Date(e.date).toLocaleString()}</small>
          </div>
        ))}
      </div>
    </div>
  );
}
