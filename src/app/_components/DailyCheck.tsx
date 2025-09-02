'use client'
import React, { useEffect, useState } from 'react'
import { db } from '../lib/db';
import Calendar from 'react-calendar';
import 'react-calendar/dist/Calendar.css'; 
import { ChevronLeftIcon, ChevronRightIcon} from '@heroicons/react/24/solid'

function DailyCheck() {
    const today = new Date()
    const [checkedIn, setCheckedIn] = useState<Date[]>([]);
    const [value, setValue] = useState<Date>(today);

    useEffect(() => {
        async function checkIn() {
            const data = await db.checkin.toArray();
            const dates = data.map(d => new Date(d.date));
            setCheckedIn(dates);
            const alreadyCheckedIn = dates.some(d => d.toDateString() === today.toDateString());
            if (!alreadyCheckedIn) {
                await db.checkin.add({ date: today.toISOString() });
                setCheckedIn([...dates, today]);
            }
        }
        checkIn();
    }, [])

    const tileClassName = ({ date }: { date: Date }) => {
        const isChecked = checkedIn.some(d => d.toDateString() === date.toDateString());
        const isToday = date.toDateString() === today.toDateString();
        return `
            ${isChecked ? 'bg-green-200 hover:bg-green-300' : 'hover:bg-gray-100'}
            ${isToday ? 'border-2 border-blue-500' : ''}
            rounded-full transition-colors duration-200
        `;
    };



    return (
        <div className="bg-[#F7F9FB] flex flex-col justify-center items-center shadow-xl rounded-xl pb-2 mt-8 max-w-2xl mx-auto">
            <div className="px-10 py-2 rounded-[10px] mb-6 self-start ">
                <h2 className="text-2xl font-semibold text-[#0D2A4B]">Daily Check-in</h2> 
            </div>
            <Calendar
                value={value}
               
                tileClassName={tileClassName}
                className="border-none  shadow-sm rounded-lg p-4 bg-gray-50"
                navigationLabel={({ date, label }) => (
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
    );
}

export default DailyCheck