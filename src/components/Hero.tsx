import React from 'react'
import { Ripple } from "@/components/magicui/ripple";
import { ShinyButton } from '@/components/magicui/shiny-button';
import FloatingIcons from '../components/FloatingIcons';

import BlurIn from './magicui/blur-in';
import Link from 'next/link';
import { NavbarDemo } from './NavBar';
import { TextAnimate } from './magicui/text-animate';
const Hero = () => {
    return (
        <div className="min-h-screen dark:text-white font-sans">
            {/* Hero Section */}
            <div className="relative overflow-hidden">
                {/* Ripple effect for the entire hero section */}
                <Ripple />

                {/* Floating Icons */}
                <FloatingIcons />

                {/* Navigation */}

                <NavbarDemo />

                <div className="relative z-10 flex flex-col items-center justify-center text-center px-4 sm:px-6 lg:px-8 py-20">
                    {/* Feature tag */}
                    <div className="mb-12 z-40">
                        {/*  */}
                    </div>

                    {/* Main heading */}
                    {/* <h1 className="text-5xl sm:text-6xl md:text-7xl font-bold mb-6 leading-tight max-w-4xl">
                        TaskFlow is the new way to manage your tasks.
                    </h1> */}
                    <BlurIn
                        word="WorryMate is your safe space to breathe, share and be heard"
                        className="text-5xl sm:text-2xl md:text-6xl font-bold mb-6 leading-tight max-w-4xl"
                        variant="default"
                    />

                    {/* Subheading */}
                    <TextAnimate className='text-xl sm:text-md mb-8 max-w-2xl text-[#0D2A4B] dark:text-white' animation="blurInUp" by="character" once>
                        Share your worries safely, find comfort in your own language, and take  small steps toward a calmer mind with your AI-powered buddy.
                    </TextAnimate>
                    {/* <p className="text-xl sm:text-md mb-8 max-w-2xl text-[#0D2A4B] dark:text-white">
                    </p> */}


                    {/* CTA Button */}
                    <Link href="/vent">
                        <ShinyButton className=" bg-[#0D2A4B] dark:bg-[#10B981] text-white rounded-3xl hover:bg-[#071b32] dark:hover:bg-[#059669]">
                            <span className='text-white'>Get Started</span>
                            <span className="ml-2 text-white">→</span>
                        </ShinyButton>
                    </Link>
                </div>
            </div>

            {/* Rest of the component... */}
        </div>
    )
}

export default Hero