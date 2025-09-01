"use client"
import Sidebar from '@/components/Sidebar'
import { Mic, Send } from 'lucide-react'
import React, { useState } from 'react'

const Workspace = () => {
    type ChatMessage = { role: 'user' | 'assistant', content: string }
    const [sidebarCollapsed, setSidebarCollapsed] = useState(false)
    const [prompt, setPrompt] = useState('')
    const [isListening, setIsListening] = useState(false)
    const [isMuted, setIsMuted] = useState(false)
    const [messages, setMessages] = useState<ChatMessage[]>([])
    const [actionCards, setActionCards] = useState<any[]>([])
    const [isCrisisMode, setIsCrisisMode] = useState(false)
    const [hasStarted, setHasStarted] = useState(false)
    const toggleSidebar = () => {
        setSidebarCollapsed(!sidebarCollapsed)
    }
    const handleSend = async () => {
        const trimmed = prompt.trim()
        if (!trimmed) return
        setMessages(prev => [...prev, { role: 'user', content: trimmed }])
        setPrompt('')
        if (!hasStarted) setHasStarted(true)

        // Pipeline: POST /risk-check → POST /map-intent → GET/POST /compose
        try {
            // 1. risk-check
            const riskRes = await fetch('/api/risk-check', {
                method: 'POST',
                headers: { 'content-type': 'application/json' },
                body: JSON.stringify({ content: trimmed })
            })
            console.log(riskRes.headers.get('content-type'))

            const riskData = await riskRes.json()
            console.log(riskData)
            if (!riskRes.ok) {
                console.log('risk-check error', riskData)
            }

            const risk = Number(riskData?.risk)
            const riskTags = riskData?.tags || []

            if (risk === 3) {
                // Crisis: fetch crisis resources and enter crisis mode
                setIsCrisisMode(true)
                try {
                    const res = await fetch('/api/resources')
                    const data = await res.json().catch(() => ({}))
                    if (!res.ok) {
                        console.log('resources error', data)
                        return
                    }
                    const resourcesPayload = data?.["resources: "] || data?.resources || data
                    const region = resourcesPayload?.region
                    const resources = resourcesPayload?.resources || []
                    const safety = resourcesPayload?.safety_plan || []

                    setActionCards(prev => [...prev, {
                        __crisis: true,
                        title: 'Immediate Support Resources',
                        description: region ? `Region: ${region}` : 'Crisis support resources near you.',
                        steps: safety.map((s: any) => `${s.step}. ${s.instruction}`),
                        miniTools: resources.map((r: any) => ({
                            title: `${r.name} (${r.type})`,
                            url: r?.contact?.website || (r?.contact?.phone ? `tel:${r.contact.phone}` : '#')
                        })),
                        ifWorse: 'If you feel unsafe, contact emergency services immediately.',
                        disclaimer: 'This is not medical advice.'
                    }])
                } catch (e) {
                    console.log('Failed fetching crisis resources', e)
                }
                return
            }

            // 2. map - intent
            let mapRes = await fetch('/api/map_intent', {
                method: 'POST',
                headers: { 'content-type': 'application/json' },
                body: JSON.stringify({ content: trimmed })
            })

            const mapData = await mapRes.json()
            console.log(mapData)
            if (!mapRes.ok) {
                console.log('map-intent error', mapData)
                setMessages(prev => [...prev, { role: 'assistant', content: 'Sorry, I could not understand the topic right now.' }])
                return
            }
            const topicKey = mapData?.topic_key
            if (!topicKey) {
                setMessages(prev => [...prev, { role: 'assistant', content: 'Sorry, I could not find a helpful topic yet.' }])
                return
            }
            console.log(topicKey)

            // 3. action-block by topic
            const actionBlockRes = await fetch(`/api/action-block?topic=${encodeURIComponent(String(topicKey))}`, { method: 'GET' })
            const actionBlockData = await actionBlockRes.json().catch(() => ({}))
            if (!actionBlockRes.ok) {
                console.log('action-block error', actionBlockData)
                setMessages(prev => [...prev, { role: 'assistant', content: 'Sorry, I could not load the action block.' }])
                return
            }
            const block = actionBlockData?.actionBlock || actionBlockData?.Block || actionBlockData?.block

            // 4. compose full card from backend
            const composeRes = await fetch('/api/compose', {
                method: 'POST',
                headers: { 'content-type': 'application/json' },
                body: JSON.stringify({ topic: topicKey, action_block: block })
            })
            const composeData = await composeRes.json().catch(() => ({}))
            if (!composeRes.ok) {
                console.log('compose error', composeData)
                return
            }

            let cardPayload: any = composeData?.card ?? composeData
            let parsedObj: any
            if (typeof cardPayload === 'string') {
                const stripped = cardPayload
                    .replace(/^```json\n?/i, '')
                    .replace(/\n?```\s*$/i, '')
                    .trim()
                parsedObj = JSON.parse(stripped)
            } else {
                parsedObj = cardPayload
            }
            const firstKey = Object.keys(parsedObj)[0]
            const cardObj = parsedObj[firstKey] ?? parsedObj
            setActionCards(prev => [...prev, { ...cardObj, __crisis: false }])
        } catch (e) {
            console.log('Pipeline failed', e)
        }
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
            <div className='flex flex-col flex-1 relative items-stretch h-screen min-h-0'>
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

                {(messages.length > 0 || actionCards.length > 0) && (
                    <div className='w-full flex-1 overflow-y-auto px-4 pt-8 self-stretch'>
                        <div className='mx-auto w-full max-w-[700px]'>
                            {messages.map((msg, idx) => {
                                const isUser = msg.role === 'user'
                                return (
                                    <div key={idx} className={`w-full flex ${isUser ? 'justify-end' : 'justify-start'} mb-3`}>
                                        <div className={`max-w-[85%] border rounded-lg px-3 py-2 ${isUser ? 'bg-[#eaf6ff] text-[#2a4461]' : 'bg-white text-[#2a4461]'}`}>
                                            {msg.content}
                                        </div>
                                    </div>
                                )
                            })}
                            {actionCards.map((card, idx) => (
                                <div key={`card-${idx}`} className='w-full flex justify-start mb-4'>
                                    <div className={`w-full max-w-[85%] border rounded-lg p-4 ${card.__crisis ? 'bg-red-50 border-red-300 text-red-800' : 'bg-white text-[#2a4461]'}`}>
                                        <h2 className='text-lg font-semibold mb-1'>{card.title}</h2>
                                        {card.description && (
                                            <p className='text-sm text-gray-700 mb-3'>{card.description}</p>
                                        )}
                                        {Array.isArray(card.steps) && card.steps.length > 0 && (
                                            <div className='mb-3'>
                                                <h3 className='font-medium mb-1'>Steps</h3>
                                                <ul className='list-disc pl-5 space-y-1'>
                                                    {card.steps.map((s: string, i: number) => (
                                                        <li key={i} className='text-sm'>{s}</li>
                                                    ))}
                                                </ul>
                                            </div>
                                        )}
                                        {Array.isArray(card.miniTools) && card.miniTools.length > 0 && (
                                            <div className='mb-3'>
                                                <h3 className='font-medium mb-1'>Mini Tools</h3>
                                                <div className='flex flex-wrap gap-2'>
                                                    {card.miniTools.map((t: any, i: number) => (
                                                        <a key={i} href={t.url} target='_blank' rel='noreferrer' className='text-blue-600 underline text-sm'>
                                                            {t.title}
                                                        </a>
                                                    ))}
                                                </div>
                                            </div>
                                        )}
                                        {card.ifWorse && (
                                            <p className='text-sm text-gray-700 mb-2'><span className='font-medium'>If worse:</span> {card.ifWorse}</p>
                                        )}
                                        {card.disclaimer && (
                                            <p className='text-xs text-gray-500 italic'>{card.disclaimer}</p>
                                        )}
                                    </div>
                                </div>
                            ))}
                        </div>
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
                {!isCrisisMode ? (
                    <div className="w-full flex-shrink-0 flex flex-col items-center justify-center pb-6">
                        <h1 className='mx-auto text-blue font-bold mb-2'>General wellbeing advice, not medical advice.</h1>
                        <div className="border rounded-lg overflow-hidden mt-2 flex w-[700px] h-28 bg-white sticky bottom-0">
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
                ) : (
                    <div className="w-full flex-shrink-0 flex flex-col items-center justify-center pb-6">
                        <div className="text-center">
                            <p className="text-red-600 font-medium mb-4">Crisis mode active - Chat disabled for your safety</p>
                            <button
                                onClick={() => {
                                    setIsCrisisMode(false)
                                    setMessages([])
                                    setActionCards([])
                                    setHasStarted(false)
                                    setPrompt('')
                                }}
                                className="px-6 py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors"
                            >
                                Reset Chat & Start Fresh
                            </button>
                        </div>
                    </div>
                )}
            </div>
        </div>
    )
}

export default Workspace