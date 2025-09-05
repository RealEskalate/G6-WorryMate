'use client'
import React, { useState, useEffect } from 'react'
import Image from 'next/image'
import image from "../../../../public/Chatbot.png"
import EmojiSelection from './EmojiSelection'
type Quote = {
  text: string;
  author: string | null;
};
const motivationalKeywords = [
  'success',
  'inspiration',
  'motivation',
  'hope',
  'dream',
  'achieve',
  'believe',
  'courage',
  'perseverance',
  'strength',
  'positive',
  'goal',
  'aspire',
  'uplift',
  'determination',
];

function HowFeel() {
  const [show, setShow] = useState(false)
  const [quote, setQuote] = useState<Quote>()

  const fetchQuote = async () => {
    try {
      const res = await fetch('https://type.fit/api/quotes', { cache: 'no-store' });
      if (!res.ok) {
        throw new Error(`HTTP error! status: ${res.status}`);
      }
      const data: Quote[] = await res.json();
      const motivationalQuotes = data.filter(
        (q) => {
          q.text.length <= 100;
          motivationalKeywords.some((keyword) => q.text.toLowerCase().includes(keyword));
        }
      )
      const randomQuote = motivationalQuotes[Math.floor(Math.random() * motivationalQuotes.length)] || data.find((q) => q.text.length <= 100) || data[0];
      setQuote(randomQuote);
    } catch (err) {
      console.log(err);
    }
  }
  useEffect(() => {
    fetchQuote();
  }, [])

  const timecheck = () => {
    const hour = new Date().getHours()
    if (hour >= 5 && hour < 12) return 'Good Morning 🌅'
    else if (hour >= 12 && hour < 17) return 'Good Afternoon 🌞'
    else if (hour >= 17 && hour < 21) return 'Good Evening 🌇'
    else return 'Burning the midnight oil? 🌃'
  }

  return (
    <div className="w-[90%] relative flex flex-col md:flex-row items-start justify-between bg-[#F7F9FB] dark:bg-[#092B47] rounded-xl shadow-md  max-w-5xl mx-auto overflow-hidden p-6">

      <div className="flex flex-col gap-4 md:w-1/2 z-10 text-[#0D2A4B] dark:text-white">
        <h1 className='text-2xl font-semibold'>{quote?.text}</h1>
        <h2 className="text-xl font-semibold dark:text-[#10B981]">{`${timecheck()}, How do you feel?`}</h2>
        <p className="text-base opacity-90 ">Please, mark your mood today</p>
        <button
          onClick={() => setShow(!show)}
          className="bg-[#0D2A4B] dark:bg-[#10B981] text-white px-4 py-2 rounded-md font-medium hover:bg-[#0c2847] transition"
        >
          {show ? 'Hide' : 'Mark now'}
        </button>
        {show && (
          <div className="mt-4">
            <EmojiSelection />
          </div>
        )}
      </div>


      <div className="absolute right-0 top-0 bottom-0 w-1/2 hidden md:block">
        <Image
          src={image}
          alt="Chatbot Illustration"
          fill
          className="object-cover opacity-80"
          priority
        />
      </div>
    </div>
  )
}

export default HowFeel
