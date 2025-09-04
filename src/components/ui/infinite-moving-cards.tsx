'use client';

import React, { useEffect, useState } from 'react';
import Link from 'next/link';
import { cn } from '@/lib/utils';

export interface FeatureCard {
  title: string;
  description: string;
  image: string;
  buttonText: string;
  buttonLink: string;
}

export const InfiniteMovingCards = ({
  items,
  direction = 'left',
  speed = 'fast',
  pauseOnHover = true,
  className,
}: {
  items: FeatureCard[];
  direction?: 'left' | 'right';
  speed?: 'fast' | 'normal' | 'slow';
  pauseOnHover?: boolean;
  className?: string;
}) => {
  const containerRef = React.useRef<HTMLDivElement>(null);
  const scrollerRef = React.useRef<HTMLUListElement>(null);
  const [start, setStart] = useState(false);

  useEffect(() => {
    if (!containerRef.current || !scrollerRef.current) return;

    
    const scrollerContent = Array.from(scrollerRef.current.children);
    scrollerContent.forEach((item) => {
      const cloned = item.cloneNode(true);
      scrollerRef.current?.appendChild(cloned);
    });

    if (containerRef.current) {
      containerRef.current.style.setProperty(
        '--animation-direction',
        direction === 'left' ? 'forwards' : 'reverse'
      );
      const duration =
        speed === 'fast' ? '20s' : speed === 'normal' ? '40s' : '80s';
      containerRef.current.style.setProperty('--animation-duration', duration);
    }

    setStart(true);
  }, [items, direction, speed]);

  const handleMouseEnter = () => {
    if (pauseOnHover && scrollerRef.current) {
      console.log('Hover detected');
      scrollerRef.current.style.animationPlayState = 'paused';
    }
  };

  const handleMouseLeave = () => {
    if (pauseOnHover && scrollerRef.current) {
      scrollerRef.current.style.animationPlayState = 'running';
    }
  };

  return (
    <div
      ref={containerRef}
      className={cn(
        'scroller relative max-w-7xl overflow-hidden [mask-image:linear-gradient(to_right,transparent,white_20%,white_80%,transparent)]',
        className
      )}
      onMouseEnter={handleMouseEnter}
      onMouseLeave={handleMouseLeave}
    >
      <ul
        ref={scrollerRef}
        className={cn(
          'flex gap-6 w-max min-w-full shrink-0 flex-nowrap py-4',
          start && 'animate-scroll'
        )}
      >
        {items.map((item, idx) => (
          <li
            key={idx}
            className="relative w-[300px] md:w-[400px] lg:w-[450px] flex-shrink-0 rounded-2xl overflow-hidden shadow-lg"
          >
            
            <div
              className="absolute inset-0 bg-cover bg-center"
              style={{ backgroundImage: `url(${item.image})` }}
            />
         
            <div className="absolute inset-0 bg-gradient-to-t from-black/70 via-black/40 to-transparent" />
      
            <div className="relative z-10 p-6 flex flex-col justify-end h-full text-[#F7F9FB]">
              <h3 className="text-lg md:text-xl font-bold">{item.title}</h3>
              <p className="mt-2 text-sm md:text-base">{item.description}</p>
              <Link
                href={item.buttonLink}
                className="mt-4 inline-block rounded-2xl bg-[#0D2A4B] px-4 py-2 text-sm font-medium hover:bg-[#0b294a] transition"
              >
                {item.buttonText}
              </Link>
            </div>
          </li>
        ))}
      </ul>

      <style jsx>{`
        @keyframes scroll {
          0% {
            transform: translateX(0);
          }
          100% {
            transform: translateX(-50%);
          }
        }

        .animate-scroll {
          animation: scroll var(--animation-duration) linear infinite;
          animation-direction: var(--animation-direction);
        }
      `}</style>
    </div>
  );
};

export default InfiniteMovingCards;