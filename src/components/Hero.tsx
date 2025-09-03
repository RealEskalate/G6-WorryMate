import React from 'react'
import { Star } from 'lucide-react'
import { Button } from "@/components/ui/button"
import { Ripple } from "@/components/magicui/ripple";
import { ShinyButton } from '@/components/magicui/shiny-button';
import { ShimmerButton } from '@/components/magicui/shimmer-button';
import FloatingIcons from '../components/FloatingIcons';

import { Moon, Sun } from "lucide-react"
import BlurIn from './magicui/blur-in';
import Link from 'next/link';
import { NavbarDemo } from './NavBar';
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
                    <p className="text-xl sm:text-md mb-8 max-w-2xl text-[#2a4461]">
                        Share your worries safely, find comfort in your own language, and take small steps toward a calmer mind with your AI-powered buddy.
                    </p>


                    {/* CTA Button */}
                    <Link href="/vent">
                        <ShinyButton className=" bg-[#2a4461] text-white rounded-3xl  hover:bg-blue-900/50 hover:text-black">
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