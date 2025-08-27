"use client"
import Sidebar from '@/components/Sidebar'
import { Mic, Send } from 'lucide-react'
import React, { useState } from 'react'

const Workspace = () => {
    const [sidebarCollapsed, setSidebarCollapsed] = useState(false)
    const [prompt, setPrompt] = useState('')
    const [isListening, setIsListening] = useState(false)
    const [isMuted, setIsMuted] = useState(false)
    const [messages, setMessages] = useState<string[]>([])
    const [hasStarted, setHasStarted] = useState(false)
    const toggleSidebar = () => {
        setSidebarCollapsed(!sidebarCollapsed)
    }
    const handleSend = () => {
        const trimmed = prompt.trim()
        if (!trimmed) return
        setMessages(prev => [...prev, trimmed])
        setPrompt('')
        if (!hasStarted) setHasStarted(true)
    }
    const sampleQuestions = [
        "I'm really stressed about my exams",
        "I lost my job and I'm worried about money",
        "My family and I keep fighting"
        // "ስለ ፈተናዬ በጣም ተጨንቄያለሁ",
        // "እኔና ቤተሰቤ እንከራከራለን"
    ];
    return (
        <div className='h-screen flex flex-row min-h-screen text-[#2a4461]  bg-[#ffffff]'>
            <div className='items-start'>
                <Sidebar isCollapsed={sidebarCollapsed} onToggle={toggleSidebar} />
            </div>
            <div className='flex flex-col flex-1 relative items-center min-h-screen '>
                {!hasStarted && messages.length === 0 && (
                    <div className='flex flex-col gap-3 justify-center items-center flex-1 pt-16'>
                        <h1 className='font-bold text-2xl'>Hey Mate, How can i Help you today?</h1>
                        <div>
                            {sampleQuestions.map((question, index) => (
                                <div className='flex flex-col gap-y-3' key={index}>
                                    <button
                                        className='w-full text-left m-1 p-2 text-sm border rounded-lg cursor-pointer hover:bg-white transition-colors'
                                        onClick={() => setPrompt(question)}
                                    >
                                        {question}
                                    </button>
                                </div>
                            ))}
                        </div>
                    </div>
                )}

                {messages.length > 0 && (
                    <div className='w-full max-w-[700px] flex-1 overflow-y-auto px-4 pt-8 pb-40'>
                        {messages.map((msg, idx) => (
                            <div key={idx} className='w-full flex justify-end mb-3'>
                                <div className='max-w-[85%] bg-[#eaf6ff] text-[#2a4461] border rounded-lg px-3 py-2'>
                                    {msg}
                                </div>
                            </div>
                        ))}
                    </div>
                )}
                {/* Listening overlay */}
                {isListening && (
                    <div className="fixed inset-0 z-80 flex items-center justify-center bg-white">
                        <div className="flex flex-col items-center gap-6 bg-white rounded-xl p-8 ">
                            <div className="relative h-24 w-24 flex items-center justify-center">
                                <span className="absolute inline-flex h-full w-full rounded-full bg-blue-500 opacity-30 animate-ping"></span>
                                <span className="relative inline-flex rounded-full h-20 w-20 bg-blue-500/80"></span>
                            </div>
                            <div className="text-center">
                                <p className="text-lg font-semibold">Listening...</p>
                                <p className="text-sm text-gray-600">Speak now</p>
                            </div>
                            <div className="flex items-center gap-3">
                                <button
                                    className="px-4 py-2 rounded-md border text-sm hover:bg-gray-50 cursor-pointer"
                                    onClick={() => setIsListening(false)}
                                >
                                    Close
                                </button>
                                <button
                                    className="px-4 py-2 rounded-md bg-blue-600 text-white text-sm hover:bg-blue-700 cursor-pointer"
                                    onClick={() => setIsMuted((m) => !m)}
                                >
                                    {isMuted ? 'Unmute' : 'Mute'}
                                </button>
                            </div>
                        </div>
                    </div>
                )}
                {/* Composer */}
                <div className="absolute bottom-0 left-0 w-full flex flex-col items-center justify-center pb-6">
                    <h1 className='mx-auto text-blue font-bold mb-2'>General wellbeing advice, not medical advice.</h1>
                    <div className="border rounded-lg overflow-hidden mt-2 flex w-[700px] h-28 ">
                        <div className="flex items-stretch gap-3 p-4 w-full">
                            <div className="flex-1">
                                <textarea
                                    value={prompt}
                                    onChange={(e) => setPrompt(e.target.value)}
                                    placeholder="Tell me what's worrying you so i can help.."
                                    className="w-full h-full border-secondary-blue bg-transparent text-left resize-none outline-none"
                                />
                            </div>
                            <button className="text-blue cursor-pointer  p-2 rounded-lg transition-colors" onClick={() => setIsListening(true)}>
                                <Mic className="w-5 h-5" />
                            </button>
                            <button className=" p-2 rounded-lg  transition-colors cursor-pointer" onClick={handleSend}>
                                <Send className="w-5 h-5" />
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    )
}

export default Workspace