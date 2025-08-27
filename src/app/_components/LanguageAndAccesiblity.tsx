'use client'
import React, { useState } from 'react'
import { useForm } from 'react-hook-form'

type Props = {
  Language: string
  FontSize: number
}

function LanguageAndAccessibility() {
  const { register, setValue, handleSubmit, watch } = useForm<Props>()
  const selectedLanguage = watch("Language", "English")
  const selectedFontSize = watch("FontSize", 16)

  return (
    <div className=' w-1/2 rounded-3xl bg-[white] text-[#132A4F] h-auto drop-shadow-white'>
      <form className="space-y-6">
    
        <h2 className="bg-[#132A4F] text-white text-center py-2">
          Languages and Accessibility
        </h2>

        <div className='flex gap-10'>
          <h3 className="mb-1">Language:</h3>
          <select
            {...register("Language")}
            value={selectedLanguage}
            onChange={(e) => setValue("Language", e.target.value)}
            className="py-1 px-2 text-white bg-[#132A4F] border border-gray-300 focus:border-indigo-500 focus:ring-2 focus:ring-indigo-200 text-base outline-none leading-8 transition-colors duration-200 ease-in-out rounded-md"
          >
            <option value="English">English</option>
            <option value="Amharic">Amharic</option>
            <option value="Device">Device</option>
          </select>
        </div>

        {/* Font Size Slider */}
        <div>
          <h3 className="mb-2">Font Size</h3>

          {/* Preview */}
         
          <div className="relative w-full max-w-md">
            <input
              {...register("FontSize", { valueAsNumber: true })}
              type="range"
              min={12}
              max={32}
              step={2}
              value={selectedFontSize}
              onChange={(e) => setValue("FontSize", Number(e.target.value))}
              className="w-full h-2 bg-gray-200 rounded-lg appearance-none cursor-pointer accent-indigo-600"
            />

            <div className="flex justify-between mt-2 text-xs text-gray-500">
              {[12, 16, 20, 24, 28, 32].map((tick) => (
                <span key={tick}>{tick}</span>
              ))}
            </div>
          </div>
           <div
            style={{ fontSize: `${selectedFontSize}px` }}
            className="font-medium mb-4"
          >
            The quick brown fox jumps over the lazy dog
          </div>
        </div>
      </form>
    </div>
  )
}

export default LanguageAndAccessibility
