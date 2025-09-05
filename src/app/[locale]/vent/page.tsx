'use client'
import OtherCard from '@/components/OtherCard'
import ActionCard from '@/components/ActionCard'
import GeneralSupportCard from '@/components/GeneralSupportCard'
import { Mic, Send } from 'lucide-react'
import React, { useEffect, useRef, useState } from 'react'
import { ActionCardData, ActionStep, CrisisCardData } from '@/types'
import { AuroraText } from '@/components/magicui/aurora-text'
import { useTranslations } from 'next-intl'
import { LoaderOne } from '@/components/ui/loader'
import { PageHeader } from '@/components/PageHeader'
import { useParams } from 'next/navigation'



const Workspace = () => {

    const t = useTranslations('Workspace')
    type ChatMessage = { role: 'user' | 'assistant', content: string }
    const [prompt, setPrompt] = useState('')
    const [isListening, setIsListening] = useState(false)
    const [messages, setMessages] = useState<ChatMessage[]>([])
    const [actionCards, setActionCards] = useState<ActionCardData[]>([])
    const [isCrisisMode, setIsCrisisMode] = useState(false)
    const [crisisCard, setCrisisCard] = useState<CrisisCardData | null>(null)
    const [isCrisisLoading, setIsCrisisLoading] = useState(false)
    const [hasStarted, setHasStarted] = useState(false)
    const [showRateLimit, setShowRateLimit] = useState(false)
    const [isLoading, setIsLoading] = useState(false)
    const  {locale}  = useParams()

    const language = locale === 'en' ? 'en-US' : 'am-ET'

    const apiLang = locale === 'am' ? 'am' : 'en'

    const recognitionRef = useRef<SpeechRecognitionClass | null>(null);

    useEffect(() => {
        if (typeof window === 'undefined') return;

        const SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;
        if (!SpeechRecognition) return;
        const rec = new SpeechRecognition();
        rec.continuous = true;
        rec.interimResults = true;
        rec.lang = language;

        rec.onresult = (event: SpeechRecognitionEvent) => {
            let transcript = '';
            for (let i = event.resultIndex; i < event.results.length; i++) {
                transcript += event.results[i][0].transcript;
            }
            setPrompt(prompt + ' ' + transcript);
        };

        rec.onend = () => {
            if (isListening) rec.start();
        };

        recognitionRef.current = rec;
    }, [language, isListening]);

    const startListening = () => {
        if (!recognitionRef.current) return alert('Your browser does not support speech recognition.');
        setIsListening(true);
        recognitionRef.current.start();
    };

    const stopListening = () => {
        recognitionRef.current?.stop();
        setIsListening(false);
    };

    const handleSend = async () => {
        const trimmed = prompt.trim()
        if (!trimmed) return
        setMessages(prev => [...prev, { role: 'user', content: trimmed }])
        setPrompt('')
        if (!hasStarted) setHasStarted(true)
        // Reset rate limit state when user sends a new message
        setShowRateLimit(false)
        // Start loading
        setIsLoading(true)

        try {
            // 1. risk-check
            const riskRes = await fetch('/api/risk-check', {
                method: 'POST',
                headers: { 'content-type': 'application/json', 'x-locale': apiLang },
                body: JSON.stringify({ content: trimmed })
            })
            const riskData = await riskRes.json()
            if (!riskRes.ok) {
                console.log('risk-check error', riskData)
            }

            const risk = Number(riskData?.risk)
            const riskTags: string[] = Array.isArray(riskData?.tags) ? riskData.tags : []

            if (risk === 3) {
                // Crisis: enter crisis mode and fetch crisis card using tags
                setIsCrisisMode(true)
                setIsCrisisLoading(true)
                try {
                    const resp = await fetch('/api/crisis-card', {
                        method: 'POST',
                        headers: { 'content-type': 'application/json', 'x-locale': apiLang },
                        body: JSON.stringify({ tags: riskTags })
                    })
                    const data = await resp.json().catch(() => ({}))
                    if (!resp.ok) {
                        console.log('crisis-card error', data)
                        setIsCrisisLoading(false)
                        return
                    }
                    let payload: unknown = data?.["Crisis-card: "] ?? data?.card ?? data
                    if (typeof payload === 'string') {
                        const stripped = payload
                            .replace(/^```json\n?/i, '')
                            .replace(/\n?```\s*$/i, '')
                            .trim()
                        payload = JSON.parse(stripped)
                    }
                    setCrisisCard(payload as CrisisCardData)
                } catch (e) {
                    console.log('Failed fetching crisis card', e)
                } finally {
                    setIsCrisisLoading(false)
                }
                return
            }

            // 2. map - intent
            const mapRes = await fetch('/api/map_intent', {
                method: 'POST',
                headers: { 'content-type': 'application/json', 'x-locale': apiLang },
                // make sure backend knows the selected language
                body: JSON.stringify({ content: trimmed, language: apiLang })
            })

            const mapData = await mapRes.json()
            if (!mapRes.ok) {
                console.log('map-intent error', mapData)
                setMessages(prev => [...prev, { role: 'assistant', content: 'Sorry, I could not understand the topic right now.' }])
                return
            }
            const topicKey = mapData?.topic_key
            // Force language to the selected app locale to avoid backend defaulting to EN
            const lang = apiLang
            if (!topicKey) {
                setMessages(prev => [...prev, { role: 'assistant', content: 'Sorry, I could not find a helpful topic yet.' }])
                return
            }

            // Special handling for "other" topic key
            if (topicKey === 'other') {
                // Add a special marker to indicate this should render GeneralSupportCard
                const otherCard: ActionCardData = {
                    title: "General Support",
                    description: "",
                    steps: [],
                    miniTools: [],
                    uiTools: [],
                    ifWorse: "",
                    disclaimer: "",
                    empathyOpeners: [],
                    scripts: [],
                    __crisis: false,
                    __isGeneralSupport: true, // Special flag to identify this card type
                }
                setActionCards(prev => [...prev, otherCard])
                return
            }

            // 3. action-block by topic
            const actionBlockRes = await fetch(`/api/action-block?topic=${encodeURIComponent(String(topicKey))}&locale=${encodeURIComponent(lang)}`, { method: 'GET', headers: { 'x-locale': apiLang } })
            const actionBlockData = await actionBlockRes.json().catch(() => ({}))
            if (!actionBlockRes.ok) {
                console.log('action-block error', actionBlockData)
                setMessages(prev => [...prev, { role: 'assistant', content: 'Sorry, I could not load the action block.' }])
                return
            }
            const block = actionBlockData.block ?? actionBlockData.action_block ?? actionBlockData.actionBlock

            // 4. compose full card from backend
            const composeRes = await fetch('/api/compose', {
                method: 'POST',
                headers: { 'content-type': 'application/json', 'x-locale': apiLang },
                body: JSON.stringify({ topic: topicKey, action_block: block, language: lang })
            })
            console.log('composeRes status:', composeRes)
            const composeData = await composeRes.json()
            console.log('composeData:', composeData)
            if (!composeRes.ok) {
                console.log('compose error', composeData)
                // Check if it's a rate limit error (429)
                if (composeRes.status === 429) {
                    setShowRateLimit(true)
                    setMessages(prev => [...prev, { role: 'assistant', content: 'Rate limit reached. Please try again later or upgrade to premium.' }])
                    return
                }
                return
            }

            console.log('composeData:', composeData)

            // The compose API returns data in a 'card' field as a JSON string
            let cardPayload: unknown = composeData?.card ?? composeData?.action_block ?? composeData
            console.log('cardPayload:', cardPayload)

            // Only parse if it's a string
            if (typeof cardPayload === "string") {
                const stripped = cardPayload
                    .replace(/^```json\n?/i, "")
                    .replace(/\n?```\s*$/i, "")
                    .trim()

                try {
                    cardPayload = JSON.parse(stripped)
                } catch (e) {
                    console.error("Failed to parse card string:", e, stripped)
                }
            }

            // Handle the weird `""` root key case
            if (typeof cardPayload === 'object' && cardPayload !== null && (cardPayload as Record<string, unknown>)[""]) {
                cardPayload = (cardPayload as Record<string, unknown>)[""];
            }

            // Unwrap if the payload is an object with a single key
            if (
                typeof cardPayload === "object" &&
                cardPayload !== null &&
                Object.keys(cardPayload).length === 1
            ) {
                const firstKey = Object.keys(cardPayload as Record<string, unknown>)[0];
                cardPayload = (cardPayload as Record<string, unknown>)[firstKey];
            }

            console.log("final cardPayload:", cardPayload)

            // Now normalize to UI format
            const normalized = cardPayload as Record<string, unknown>
            const transformedCard: ActionCardData = {
                title:
                    (normalized.title as string | undefined) ??
                    `Action Plan for ${topicKey?.replace(/_/g, " ").replace(/\b\w/g, (l) => l.toUpperCase()) || "Your Concern"}`,
                description: (normalized.description as string | undefined) ?? "Here's a plan to help you with your concern.",
                steps: (normalized.micro_steps as ActionStep[] | undefined)
                    ?? (normalized.steps as ActionStep[] | undefined)
                    ?? [],
                miniTools: (normalized.tool_links as Array<{ title: string; url: string }> | undefined)
                    ?? (normalized.miniTools as Array<{ title: string; url: string }> | undefined)
                    ?? [],
                uiTools: (normalized.uiTools as unknown[]) ?? [],
                ifWorse: (normalized.if_worse as string | undefined)
                    ?? (normalized.ifWorse as string | undefined)
                    ?? "",
                disclaimer: (normalized.disclaimer as string | undefined) ?? "",
                empathyOpeners: (normalized.empathy_openers as string[] | undefined) ?? [],
                scripts: (normalized.scripts as string[] | undefined) ?? [],
                __crisis: false,
            }

            console.log('transformedCard:', transformedCard)
            setActionCards(prev => [...prev, transformedCard])
        } catch (e) {
            console.log('Pipeline failed', e)
        } finally {
            // Stop loading
            setIsLoading(false)
        }
    }
    // const sampleQuestions = [
    //     "I'm really stressed about my exams",
    //     "I lost my job and I'm worried about money",
    //     "My family and I keep fighting"
    // ];
    const sampleQuestions: string[] = t.raw('sampleQuestions')

    return (
        <div className='flex flex-col flex-1 relative items-stretch h-screen min-h-0 bg-white dark:bg-gray-900'>
            <PageHeader title="Vent" />
            {!hasStarted && messages.length === 0 && (
                <div className='flex flex-col gap-3 justify-center items-center flex-1 pt-16 px-4'>
                    <h1 className='font-bold text-xl md:text-2xl text-center text-gray-900 dark:text-white'>
                        {t('welcomePrefix')} <AuroraText>{t('welcomeMate')}</AuroraText>
                    </h1>
                    <div className='w-full max-w-md'>
                        {sampleQuestions.map((question, index) => (
                            <div className='flex flex-col gap-y-3' key={index}>
                                <button
                                    className='w-full text-left m-1 p-2 text-sm border rounded-lg cursor-pointer hover:bg-gray-50 dark:hover:bg-gray-800 bg-white dark:bg-[#0D2A4B] dark:border-[#10B981] border-[#0D2A4B] text-gray-900 dark:text-gray-100 transition-colors'
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
                <div className='w-full flex-1 overflow-y-auto px-2 md:px-4 pt-8 self-stretch'>
                    <div className='mx-auto w-full max-w-[700px]'>
                        {Array.from({ length: Math.max(messages.length, actionCards.length) }).map((_, idx) => (
                            <React.Fragment key={idx}>
                                {messages[idx] && (
                                    <div className={`w-full flex ${messages[idx].role === 'user' ? 'justify-end' : 'justify-start'} mb-3`}>
                                        <div className={`max-w-[85%] border rounded-lg px-3 py-2 ${messages[idx].role === 'user' ? 'bg-[#0D2A4B] dark:bg-transparent text-white' : 'bg-white dark:bg-gray-800 text-[#2a4461] dark:text-gray-100 border-gray-200 dark:border-gray-700'}`}>
                                            {messages[idx].content}
                                        </div>
                                    </div>
                                )}
                                {actionCards[idx] && (
                                    <div className='w-full flex justify-start mb-4'>
                                        {actionCards[idx].__crisis ? (
                                            <div className={`w-full max-w-[85%] border rounded-lg p-4 bg-red-50 border-red-300 text-red-800`}>
                                                <h2 className='text-lg font-semibold mb-1'>{actionCards[idx].title}</h2>
                                                {actionCards[idx].description && (
                                                    <p className='text-sm text-gray-700 mb-3'>{actionCards[idx].description}</p>
                                                )}
                                                {Array.isArray(actionCards[idx].steps) && actionCards[idx].steps.length > 0 && (
                                                    <div className='mb-3'>
                                                        <h3 className='font-medium mb-1'>Steps</h3>
                                                        <ul className='list-disc pl-5 space-y-1'>
                                                            {actionCards[idx].steps.map((s: ActionStep, i: number) => (
                                                                <li key={i} className='text-sm'>
                                                                    {typeof s === "string" ? s : ("step" in s ? s.step : JSON.stringify(s))}
                                                                </li>
                                                            ))}
                                                        </ul>
                                                    </div>
                                                )}
                                                {Array.isArray(actionCards[idx].empathyOpeners) && actionCards[idx].empathyOpeners.length > 0 && (
                                                    <div className='mb-3'>
                                                        <h3 className='font-medium mb-1'>Supportive Messages</h3>
                                                        <ul className='list-disc pl-5 space-y-1'>
                                                            {actionCards[idx].empathyOpeners.map((opener: string, i: number) => (
                                                                <li key={i} className='text-sm text-gray-600 italic'>{opener}</li>
                                                            ))}
                                                        </ul>
                                                    </div>
                                                )}
                                                {Array.isArray(actionCards[idx].scripts) && actionCards[idx].scripts.length > 0 && (
                                                    <div className='mb-3'>
                                                        <h3 className='font-medium mb-1'>Helpful Scripts</h3>
                                                        <ul className='list-disc pl-5 space-y-1'>
                                                            {actionCards[idx].scripts.map((script: string, i: number) => (
                                                                <li key={i} className='text-sm text-gray-700'>{script}</li>
                                                            ))}
                                                        </ul>
                                                    </div>
                                                )}
                                                {Array.isArray(actionCards[idx].miniTools) && actionCards[idx].miniTools.length > 0 && (
                                                    <div className='mb-3'>
                                                        <h3 className='font-medium mb-1'>Mini Tools</h3>
                                                        <div className='flex flex-wrap gap-2'>
                                                            {actionCards[idx].miniTools.map((t: { title: string; url: string }, i: number) => (
                                                                <a key={i} href={t.url} target='_blank' rel='noreferrer' className='text-blue-600 underline text-sm'>
                                                                    {t.title}
                                                                </a>
                                                            ))}
                                                        </div>
                                                    </div>
                                                )}
                                                {actionCards[idx].ifWorse && (
                                                    <p className='text-sm text-gray-700 mb-2'><span className='font-medium'>If worse:</span> {actionCards[idx].ifWorse}</p>
                                                )}
                                                {actionCards[idx].disclaimer && (
                                                    <p className='text-xs text-gray-500 italic'>{actionCards[idx].disclaimer}</p>
                                                )}
                                            </div>
                                        ) : actionCards[idx].__isGeneralSupport ? (
                                            <GeneralSupportCard />
                                        ) : (
                                            <ActionCard data={actionCards[idx]} />
                                        )}
                                    </div>
                                )}
                            </React.Fragment>
                        ))}

                        {/* Loading indicator */}
                        {isLoading && (
                            <div className='w-full flex justify-start mb-4'>
                                <div className='max-w-[85%] border rounded-lg px-3 py-2 bg-white dark:bg-gray-800 text-[#2a4461] dark:text-gray-100 border-gray-200 dark:border-gray-700 flex items-center gap-2'>
                                    <LoaderOne />
                                    {/* <span className='text-sm'></span> */}
                                </div>
                            </div>
                        )}

                        {/* Rate Limit Card */}
                        {showRateLimit && (
                            <div className='w-full flex justify-start mb-4'>
                                <OtherCard
                                    type="rate_limit"
                                    title="Rate Limit Reached"
                                    message="You've reached your usage limit for today. Please try again later or upgrade to premium for unlimited access."
                                    showPremium={true}
                                />
                            </div>
                        )}
                    </div>
                </div>
            )}

            {/* Crisis Card Modal */}
            {isCrisisMode && (
                <div className="fixed inset-0 z-90 flex items-center justify-center bg-black/50 animate-in fade-in duration-300">
                    <div className="animate-in slide-in-from-bottom-4 duration-300">
                        <div className="w-full max-w-md lg:max-w-2xl xl:max-w-4xl bg-white dark:bg-gray-800 rounded-2xl shadow-lg p-4 lg:p-6 border border-red-100 dark:border-red-900 relative">
                            <h2 className="text-lg lg:text-2xl font-extrabold text-red-700 dark:text-red-400 mb-1 text-center drop-shadow">Crisis Support</h2>

                            {isCrisisLoading ? (
                                <div className="flex flex-col items-center justify-center py-8">
                                    <div className="flex items-center gap-3 mb-4">
                                        <LoaderOne />
                                        <span className="text-lg font-medium text-gray-700 dark:text-gray-300">Loading crisis resources...</span>
                                    </div>
                                    <p className="text-sm text-gray-500 dark:text-gray-400 text-center">Please wait while we gather the most relevant support information for you.</p>
                                </div>
                            ) : (
                                <>
                                    {crisisCard?.region && (
                                        <p className="text-sm lg:text-base text-gray-600 dark:text-gray-400 text-center mb-3">Region: {crisisCard.region}</p>
                                    )}
                                    <h3 className="text-base lg:text-lg font-bold text-red-600 dark:text-red-400 mb-2 mt-2">Immediate Steps</h3>
                                    <div className="space-y-2 mb-4 lg:grid lg:grid-cols-2 lg:gap-4">
                                        {(crisisCard?.safety_plan || []).map((step) => (
                                            <div key={String(step.step)} className="p-2 lg:p-3 rounded-lg border border-red-100 dark:border-red-900 bg-red-50 dark:bg-red-900/20 shadow-sm flex flex-col gap-0.5">
                                                <p className="font-semibold text-red-700 dark:text-red-400 text-sm lg:text-base">Step {step.step}</p>
                                                <p className="text-gray-700 dark:text-gray-300 text-xs lg:text-sm">{step.instruction}</p>
                                            </div>
                                        ))}
                                    </div>
                                    <h3 className="text-base lg:text-lg font-bold text-red-600 dark:text-red-400 mb-2 mt-4">Resources</h3>
                                    <div className="flex flex-col gap-2 lg:grid lg:grid-cols-2 lg:gap-4">
                                        {(crisisCard?.resources || []).map((res, idx: number) => (
                                            <div key={idx} className="p-3 rounded-lg border border-gray-200 dark:border-gray-700 bg-gray-50 dark:bg-gray-700">
                                                <p className="font-semibold text-sm text-gray-800 dark:text-gray-200">{res.name} <span className="text-gray-500 dark:text-gray-400">({res.type})</span></p>
                                                {res.contact?.phone && (
                                                    <a className="text-blue-600 dark:text-blue-400 underline text-xs" href={`tel:${res.contact.phone}`}>{res.contact.phone}</a>
                                                )}
                                                {res.contact?.website && (
                                                    <a className="text-blue-600 dark:text-blue-400 underline text-xs block" target="_blank" rel="noreferrer" href={res.contact.website}>{res.contact.website}</a>
                                                )}
                                                {res.contact?.email && (
                                                    <a className="text-blue-600 dark:text-blue-400 underline text-xs block" href={`mailto:${res.contact.email}`}>{res.contact.email}</a>
                                                )}
                                                {res.contact?.availability && (
                                                    <p className="text-xs text-gray-600 dark:text-gray-400">Availability: {res.contact.availability}</p>
                                                )}
                                            </div>
                                        ))}
                                    </div>
                                    {crisisCard?.disclaimer && (
                                        <p className="text-xs text-gray-500 dark:text-gray-400 italic mt-3">{crisisCard.disclaimer}</p>
                                    )}
                                </>
                            )}

                            <button
                                onClick={() => {
                                    setIsCrisisMode(false)
                                    setMessages([])
                                    setActionCards([])
                                    setHasStarted(false)
                                    setPrompt('')
                                    setCrisisCard(null)
                                    setShowRateLimit(false)
                                    setIsCrisisLoading(false)
                                }}
                                className="flex justify-center items-center w-1/2 mx-auto mt-5 bg-red-600 dark:bg-red-500 hover:bg-red-700 dark:hover:bg-red-600 text-white font-bold py-2 px-5 rounded-md shadow transition-colors text-sm"
                                aria-label="Exit"
                            >
                                Exit
                            </button>
                        </div>
                    </div>
                </div>
            )}

            {/* Composer */}
            {!isCrisisMode ? (
                <div className="w-full flex-shrink-0 flex flex-col items-center justify-center pb-6 px-2 md:px-0">
                    {/* <h1 className='mx-auto text-blue font-bold mb-2 text-center text-sm md:text-base'>General wellbeing advice, not medical advice.</h1> */}
                    <div className="rounded-lg overflow-hidden mt-2 flex w-full max-w-[700px] h-28 sticky bottom-0 border-2 border-[#0D2A4B] dark:border-[#10B981] bg-white dark:bg-gray-800">
                        <div className="flex items-stretch gap-3 p-4 w-full">
                            <div className="flex-1">
                                <textarea
                                    value={prompt}
                                    onChange={(e) => setPrompt(e.target.value)}
                                    placeholder="Tell me what's worrying you so i can help.."
                                    className="w-full h-full border-secondary-blue bg-transparent text-left resize-none outline-none text-gray-900 dark:text-gray-100 placeholder-gray-500 dark:placeholder-gray-400"
                                    onKeyDown={(e) => {
                                        if (e.key === "Enter" && !e.shiftKey) {
                                            e.preventDefault();
                                            handleSend();
                                        }
                                    }}
                                />
                            </div>
                            <button className={`${isListening ? 'text-red-600 dark:text-red-400' : 'text-gray-600 dark:text-gray-400'} text-blue-600 dark:text-blue-400 cursor-pointer p-2 rounded-lg transition-colors hover:bg-gray-100 dark:hover:bg-gray-700`} onClick={
                                isListening ? stopListening : startListening
                            }>
                                <Mic className="w-5 h-5" />
                            </button>
                            <button className="text-blue-600 dark:text-blue-400 p-2 rounded-lg transition-colors cursor-pointer hover:bg-gray-100 dark:hover:bg-gray-700" onClick={handleSend}>
                                <Send className="w-5 h-5" />
                            </button>
                        </div>
                    </div>
                </div>
            ) : (
                <div className="w-full flex-shrink-0 flex flex-col items-center justify-center pb-6 px-2 md:px-0">
                    <div className="text-center">
                        <p className="text-red-600 dark:text-red-400 font-medium mb-4 text-sm md:text-base">Crisis mode active - Chat disabled for your safety</p>
                    </div>
                </div>
            )}
        </div>
    )
}

export default Workspace