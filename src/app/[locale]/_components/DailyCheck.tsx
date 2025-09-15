'use client';
import React, { useState, useEffect } from 'react';
import Calendar from 'react-calendar';
import 'react-calendar/dist/Calendar.css';
import { ChevronLeftIcon, ChevronRightIcon } from '@heroicons/react/24/solid';
import './calendar.css';
import { db } from '@/app/lib/db';

function formatDateOnly(date: Date): string {
  return date.toISOString().split('T')[0];
}

function normalizeDate(dateStr: string): string {
  if (/^\d{4}-\d{2}-\d{2}$/.test(dateStr)) {
    return dateStr;
  }
  try {
    return new Date(dateStr).toISOString().split("T")[0];
  } catch {
    return dateStr;
  }
}

const DailyCheck: React.FC = () => {
  const today = new Date();
  const todayStr = formatDateOnly(today);
  const [checkedIn, setCheckedIn] = useState<string[]>([]);
  const [isLoading, setIsLoading] = useState<boolean>(true);
  const [error, setError] = useState<string | null>(null);
  const [isDarkMode, setIsDarkMode] = useState<boolean>(false);

  useEffect(() => {
    async function loadCheckIns() {
      try {
        setIsLoading(true);
        const checkIns = await db.checkin.toArray();
        const dates = Array.from(new Set(checkIns.map((c) => normalizeDate(c.date))));
        setCheckedIn(dates);

        if (!dates.includes(todayStr)) {
          await db.checkin.add({ date: todayStr });
          setCheckedIn((prev) => [...prev, todayStr]);
          console.log(`Auto-added today's check-in: ${todayStr}`);
        }
      } catch (err) {
        setError(`Error loading data: ${(err as Error).message}`);
        console.error('Error loading check-ins:', err);
      } finally {
        setIsLoading(false);
      }
    }
    loadCheckIns();
  }, []);

  const tileClassName = ({ date }: { date: Date }) => {
    const dateStr = formatDateOnly(date);
    return checkedIn.includes(dateStr) ? "checked-in" : null;
  };

  return (
    <div className="w-full mx-auto p-2 sm:p-4 rounded-lg shadow-md bg-white dark:bg-[#28445C] text-gray-900 dark:text-white overflow-x-hidden">
      <div className="flex justify-between items-center px-2 sm:px-4 py-1 sm:py-2 mb-2 sm:mb-4">
        <h2 className="text-base sm:text-xl font-semibold text-gray-900 dark:text-green-400">
          Daily Check-in
        </h2>
      </div>
      {isLoading && <p className="text-gray-600 dark:text-gray-300 text-center text-sm">Loading check-in data...</p>}
      {error && <p className="text-red-500 text-center text-sm">{error}</p>}
      <div className="w-full overflow-x-hidden">
        <Calendar
          tileClassName={tileClassName}
          className="w-full bg-white dark:bg-gray-800 rounded-lg p-1 sm:p-2 border-none"
          navigationLabel={({ label }: { label: string }) => (
            <span className="text-sm sm:text-base font-semibold text-[#0D2A4B] dark:text-[#10B981]">
              {label}
            </span>
          )}
          prevLabel={
            <ChevronLeftIcon className="h-4 w-4 sm:h-5 sm:w-5 text-gray-600 hover:text-gray-800 dark:text-gray-300 dark:hover:text-gray-100" />
          }
          nextLabel={
            <ChevronRightIcon className="h-4 w-4 sm:h-5 sm:w-5 text-gray-600 hover:text-gray-800 dark:text-gray-300 dark:hover:text-gray-100" />
          }
          prev2Label={null}
          next2Label={null}
          showNeighboringMonth={false}
          minDetail="month"
        />
      </div>
    </div>
  );
};

export default DailyCheck;