'use client';

import Link from 'next/link';
import React from 'react';

const Footer = () => {
  return (
    <div className="relative">
      <div className="bg-gradient-to-r mt-5 absolute inset-0 dark:from-zinc-900 from-zinc-100 dark:via-zinc-700 via-zinc-300 dark:to-zinc-900 to-zinc-100 h-[1.5px] rounded-full "></div>
      
      <div className="max-w-[1440px] mx-auto flex md:flex-row flex-col justify-between gap-7 items-start md:p-20 p-10">
        <div className="flex flex-col gap-1">
          <Link href="/" className="text-3xl flex items-center space-x-1 font-semibold">
            <span className="font-bold sm:inline-block">WorryMate</span>
          </Link>
          <div>@{new Date().getFullYear()}</div>
          <div className="text-sm text-gray-600 dark:text-gray-400">
            Built by WorryMate team at A2SV
          </div>
        </div>

        <div className="grid grid-cols-1 gap-10 items-start">
          <div className="flex md:flex-row flex-col gap-4">
            <Link className="hover:underline" href="/vent">Chat</Link>
            <Link className="hover:underline" href="/journal">Journal</Link>
          </div>
        </div>
      </div>

      <p className="w-full text-center text-5xl md:text-9xl font-bold bg-clip-text text-transparent bg-gradient-to-b from-neutral-50 dark:from-neutral-950 to-neutral-200 dark:to-neutral-800">
        WORRYMATE
      </p>


      <div className="flex justify-center my-10">
        <a
          href="https://drive.google.com/file/d/1Dr8w3ilqYLYORHB937-msR9whwiYhzhV/view?usp=drive_link"
          target="_blank"
          rel="noopener noreferrer"
          className="px-8 py-3 bg-gradient-to-r from-indigo-500 via-purple-500 to-pink-500 text-white font-semibold rounded-full shadow-xl hover:shadow-2xl transform hover:-translate-y-1 transition-all duration-300"
        >
          Install App
        </a>
      </div>
    </div>
  );
};

export default Footer;
