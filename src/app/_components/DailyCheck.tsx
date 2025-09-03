'use client'
import React, { useEffect, useState, useCallback } from 'react'
import { db } from '../lib/db'
import Calendar from 'react-calendar'
import 'react-calendar/dist/Calendar.css'
import { ChevronLeftIcon, ChevronRightIcon } from '@heroicons/react/24/solid'

function formatDateOnly(date: Date): string {
  return date.toISOString().split('T')[0]
}

function DailyCheck() {
  const today = new Date()
  const todayStr = formatDateOnly(today)
  const [checkedIn, setCheckedIn] = useState<string[]>([])
  const [value, setValue] = useState<Date>(today)
  const [isLoading, setIsLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)

  useEffect(() => {
    async function checkIn() {
      try {
        setIsLoading(true)
        const data = await db.checkin.toArray()
        const dates = data.map(d => formatDateOnly(new Date(d.date)))
        setCheckedIn(dates)

        if (!dates.includes(todayStr)) {
          await db.checkin.add({ date: todayStr })
          setCheckedIn(prev => [...prev, todayStr])
        }
      } catch (err) {
       
        setError('Failed to load check-in data.')
      } finally {
        setIsLoading(false)
      }
    }
    checkIn()
  }, [todayStr])

  const tileClassName = useCallback(
    ({ date }: { date: Date }) => {
      const dateStr = formatDateOnly(date)
      const isChecked = checkedIn.includes(dateStr)
      const isToday = dateStr === todayStr
      console.log(`Tile: ${dateStr}, isChecked: ${isChecked}, isToday: ${isToday}`)

      const classes = [
       
        'custom-tile', 
        isChecked ? 'bg-green-200' : '',
        isChecked ? 'hover:bg-green-300' : 'hover:bg-gray-100',
        isToday ? 'border-2 border-green-500' : '',
        isChecked? 'text-white':'',
        
        'rounded-full',
        'transition-colors',
        'duration-200',
      ].filter(Boolean)

      return classes
    },
    [checkedIn, todayStr]
  )

  return (
    <div className="bg-[#F7F9FB] flex flex-col justify-center items-center shadow-xl rounded-xl pb-2 mt-8 max-w-2xl mx-auto">
      <div className="px-10 py-2 rounded-[10px] mb-6 self-start">
        <h2 className="text-2xl font-semibold text-[#0D2A4B]">Daily Check-in</h2>
      </div>
      {isLoading && <p>Loading check-in data...</p>}
      {error && <p className="text-red-500">{error}</p>}
      <Calendar
        value={value}
        onChange={(val) => {
          if (val instanceof Date) {
            setValue(val)
          }
        }}
        tileClassName={tileClassName}
        className="border-none shadow-sm rounded-lg p-4 bg-gray-50"
        navigationLabel={({ label }) => (
          <span className="text-lg font-semibold text-gray-700">{label}</span>
        )}
        prevLabel={<ChevronLeftIcon className="h-6 w-6 text-gray-600 hover:text-gray-800" />}
        nextLabel={<ChevronRightIcon className="h-6 w-6 text-gray-600 hover:text-gray-800" />}
        prev2Label={null}
        next2Label={null}
        showNeighboringMonth={false}
        minDetail="month"
      />
    </div>
  )
}

export default DailyCheck