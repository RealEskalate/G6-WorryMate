'use client'
import React, { useState, useEffect } from 'react'
import { db, JournalEntry } from '../../lib/db'
import { useParams, useRouter } from 'next/navigation'

function Page() {
  const [entry, setEntry] = useState<JournalEntry>()
  const [isEditingTitle, setIsEditingTitle] = useState(false)
  const [isEditingContent, setIsEditingContent] = useState(false)
  const [title, setTitle] = useState('')
  const [content, setContent] = useState('')

  const router = useRouter()
  const { id } = useParams()

  useEffect(() => {
    const fetchEntry = async () => {
      const data = await db.journals.get(Number(id))
      if (data) {
        setEntry(data)
        setTitle(data.title || '')
        setContent(data.content || '')
      }
    }
    fetchEntry()
  }, [id])

  const handleUpdate = async () => {
    if (!entry) return
    const updated = { ...entry, title, content }
    await db.journals.put(updated)
    setEntry(updated)
    setIsEditingTitle(false)
    setIsEditingContent(false)
  }

  if (!entry) {
    return (
      <div className="min-h-screen flex items-center justify-center text-gray-500">
        Loading journal...
      </div>
    )
  }

  return (
    <div className="min-h-screen bg-gradient-to-b from-blue-50 via-white to-blue-50 py-12 px-6 flex justify-center">
      <div className="w-full max-w-3xl bg-white shadow-xl rounded-2xl p-10 border border-gray-200">
    
        <p className="text-gray-400 text-sm mb-4 italic">
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
              className="w-full text-4xl font-serif font-bold text-gray-800 border-b border-blue-400 bg-transparent focus:outline-none"
            />
          ) : (
            <h1
              onDoubleClick={() => setIsEditingTitle(true)}
              className="text-4xl font-serif font-bold text-gray-800 cursor-pointer hover:text-blue-600"
            >
              {title || "Untitled Journal"}
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
              className="w-full text-lg font-light font-sans text-gray-700 leading-relaxed bg-transparent border border-blue-400 rounded-lg p-4 focus:outline-none shadow-inner"
            />
          ) : (
            <p
              onClick={() => setIsEditingContent(true)}
              className="text-lg font-light font-sans text-gray-700 leading-relaxed whitespace-pre-line cursor-pointer hover:bg-blue-50 rounded-lg p-3"
            >
              {content || "Click here to start writing your thoughts..."}
            </p>
          )}
        </div>

        {/* Actions */}
        <div className="flex justify-end gap-4 mt-10">
          <button
            onClick={async () => {
              await db.journals.delete(Number(id))
              router.push('/journal')
            }}
            className="bg-red-400 hover:bg-red-500 text-white rounded-xl px-6 py-2 shadow-md transition"
          >
            Delete
          </button>

          <button
            onClick={handleUpdate}
            className="bg-blue-400 hover:bg-blue-500 text-white rounded-xl px-6 py-2 shadow-md transition"
          >
            Update
          </button>
        </div>
      </div>
    </div>
  )
}

export default Page
