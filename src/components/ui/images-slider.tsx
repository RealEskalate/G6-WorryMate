"use client";
import { cn } from "../../lib/utils";
import { motion, AnimatePresence } from "framer-motion";
import React, { useEffect, useState, useCallback } from "react";

interface Slide {
  image: string;
  text?: string; 
  link?: string; 
  buttonText?: string; 
}

interface ImagesSliderProps {
  slides: Slide[];
  overlay?: boolean | React.ReactNode;
  overlayClassName?: string;
  className?: string;
  autoplay?: boolean;
}

export const ImagesSlider: React.FC<ImagesSliderProps> = ({
  slides,
  overlay = true,
  overlayClassName,
  className,
  autoplay = true,
}) => {
  const [currentIndex, setCurrentIndex] = useState(0);
  const [loadedImages, setLoadedImages] = useState<Slide[]>([]);
  const [direction, setDirection] = useState(1); 

  const handleNext = useCallback(() => {
    setDirection(1);
    setCurrentIndex((prevIndex) => (prevIndex + 1) % slides.length);
  }, [slides.length]);

  const handlePrevious = useCallback(() => {
    setDirection(-1);
    setCurrentIndex((prevIndex) =>
      prevIndex - 1 < 0 ? slides.length - 1 : prevIndex - 1
    );
  }, [slides.length]);

  
  useEffect(() => {
    const loadPromises = slides.map(
      (slide) =>
        new Promise<Slide>((resolve, reject) => {
          const img = new Image();
          img.src = slide.image;
          img.onload = () => resolve(slide);
          img.onerror = reject;
        })
    );

    Promise.all(loadPromises)
      .then((loaded) => setLoadedImages(loaded))
      .catch((err) => console.error("Failed to load images", err));
  }, [slides]);

  
  useEffect(() => {
    const handleKeyDown = (event: KeyboardEvent) => {
      if (event.key === "ArrowRight") handleNext();
      if (event.key === "ArrowLeft") handlePrevious();
    };

    window.addEventListener("keydown", handleKeyDown);

    let interval: NodeJS.Timer;
    if (autoplay) interval = setInterval(handleNext, 5000);

    return () => {
      window.removeEventListener("keydown", handleKeyDown);
      if (interval) clearInterval(interval);
    };
  }, [autoplay, handleNext, handlePrevious]);

  const areImagesLoaded = loadedImages.length > 0;

  const slideVariants = {
    enter: (dir: number) => ({
      x: dir > 0 ? "100%" : "-100%",
      opacity: 0,
    }),
    center: { x: 0, opacity: 1, transition: { duration: 0.8, ease: "easeInOut" } },
    exit: (dir: number) => ({
      x: dir > 0 ? "-100%" : "100%",
      opacity: 0,
      transition: { duration: 0.8, ease: "easeInOut" },
    }),
  };

  return (
    <div
      className={cn("overflow-hidden relative w-full h-full", className)}
    >
      {areImagesLoaded && overlay && (
        <>
          {typeof overlay === "boolean" ? (
            <div
              className={cn(
                "absolute inset-0 bg-black/50 z-40",
                overlayClassName
              )}
            />
          ) : (
            overlay
          )}
        </>
      )}

      {areImagesLoaded && (
        <AnimatePresence custom={direction}>
          <motion.div
            key={currentIndex}
            custom={direction}
            variants={slideVariants}
            initial="enter"
            animate="center"
            exit="exit"
            className="absolute inset-0 w-full h-full"
          >
            <img
              src={loadedImages[currentIndex].image}
              alt={`Slide ${currentIndex + 1}`}
              className="w-full h-full object-cover"
            />
          
            {loadedImages[currentIndex].text && (
              <div className="absolute bottom-0 left-1/2 -translate-x-1/2 -translate-y-1/2 text-center z-50 px-4">/
                <h2 className="text-white text-4xl font-bold mb-4">
                  {loadedImages[currentIndex].text}
                </h2>
                {loadedImages[currentIndex].link && loadedImages[currentIndex].buttonText && (
                  <a
                    href={loadedImages[currentIndex].link}
                    className="bg-blue-600 hover:bg-blue-700 text-white px-6 py-3 rounded-lg transition"
                  >
                    {loadedImages[currentIndex].buttonText}
                  </a>
                )}
              </div>
            )}
          </motion.div>
        </AnimatePresence>
      )}
    </div>
  );
};

export default ImagesSlider;
