'use client';
import React, { useEffect, useState } from "react";
import {
  LineChart,
  Line,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  ResponsiveContainer
} from "recharts";
import {
  startOfWeek,
  endOfWeek,
  eachDayOfInterval,
  format,
  isWithinInterval
} from "date-fns";
import { DailyEmoji, db } from "@/app/lib/db";
import { useTranslations } from "next-intl";

const emojiLevels: Record<string, number> = {
  "😞": 1,
  "😐": 2,
  "😊": 3,
  "😄": 4,
  "😍": 5,
};

const emojiLevel = (val: number) => {
  switch (val) {
    case 1: return "😞";
    case 2: return "😐";
    case 3: return "😊";
    case 4: return "😄";
    case 5: return "😍";
    default: return "";
  }
};

function EmojiProgress() {
  const [entries, setEntries] = useState<DailyEmoji[]>([]);
  const [weeks, setWeeks] = useState<{ label: string; start: Date; end: Date }[]>([]);
  const [selectedWeek, setSelectedWeek] = useState<{ start: Date; end: Date; label: string } | null>(null);
  const [weekData, setWeekData] = useState<{ date: string; mood: number | null; mood_label: string | null }[]>([]);
  const t = useTranslations('EmojiProgress');

  const moodToWord = (emoji: string) => {
    switch (emoji) {
      case "😞": return t('low');
      case "😐": return t('meh');
      case "😊": return t('okay');
      case "😄": return t('good');
      case "😍": return t('great');
      default: return "";
    }
  };

  useEffect(() => {
    async function fetchEmojis() {
      const allEntries: DailyEmoji[] = await db.dailyemoji.toArray();
      setEntries(allEntries);

      const today = new Date();
      const currentWeekStart = startOfWeek(today, { weekStartsOn: 1 });
      const currentWeekEnd = endOfWeek(today, { weekStartsOn: 1 });
      const currentWeekLabel = `${format(currentWeekStart, "MMM d")} - ${format(currentWeekEnd, "MMM d")}`;

      if (allEntries.length === 0) {
        setWeeks([{ label: currentWeekLabel, start: currentWeekStart, end: currentWeekEnd }]);
        setSelectedWeek({ label: currentWeekLabel, start: currentWeekStart, end: currentWeekEnd });
      } else {
        const dates = allEntries.map(e => new Date(e.date));
        const minDate = new Date(Math.min(...dates.map(d => d.getTime())));
        const maxDate = new Date(Math.max(...dates.map(d => d.getTime())));
        const generatedWeeks: { label: string; start: Date; end: Date }[] = [];
        let current = startOfWeek(minDate, { weekStartsOn: 1 });

        while (current <= maxDate) {
          const end = endOfWeek(current, { weekStartsOn: 1 });
          generatedWeeks.push({
            label: `${format(current, "MMM d")} - ${format(end, "MMM d")}`,
            start: current,
            end,
          });
          current = new Date(end);
          current.setDate(current.getDate() + 1);
        }

        setWeeks(generatedWeeks);

        const currentWeek = generatedWeeks.find(w => isWithinInterval(today, { start: w.start, end: w.end }));
        setSelectedWeek(currentWeek || generatedWeeks[generatedWeeks.length - 1]);
      }
    }
    fetchEmojis();
  }, []);

  useEffect(() => {
    if (!selectedWeek) return;

    const days = eachDayOfInterval({ start: selectedWeek.start, end: selectedWeek.end }).map(d => {
      const dateStr = format(d, "yyyy-MM-dd");
      const entry = entries.find(e => e.date === dateStr);
      return {
        date: format(d, "EEE dd"),
        mood: entry ? emojiLevels[entry.emoji] : null,
        mood_label: entry ? moodToWord(entry.emoji) : null
      };
    });

    setWeekData(days);
  }, [selectedWeek, entries, t]);

  return (
    <div className="p-2 sm:p-4 bg-[#F7F9FB] dark:bg-[#092B47] dark:text-white rounded-lg w-full">
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-2 sm:gap-4 mb-2 sm:mb-4 px-2">
        <div>
          <h1 className="text-base sm:text-xl font-semibold text-[#0D2A4B] dark:text-[#10B981]">{t('moodTracker')}</h1>
          <p className="text-gray-600 dark:text-gray-300 text-xs sm:text-sm">{t('trackMood')}</p>
        </div>
        <select
          className="w-full sm:w-auto border p-1 sm:p-2 rounded border-[#0D2A4B] dark:border-[#10B981] dark:text-[#10B981] bg-[#F7F9FB] dark:bg-[#092B47] text-[#0D2A4B]"
          value={selectedWeek ? selectedWeek.label : ""}
          onChange={(e) => {
            const week = weeks.find(w => w.label === e.target.value);
            if (week) setSelectedWeek(week);
          }}
        >
          <option value="">{t('selectWeek')}</option>
          {weeks.map((w, i) => (
            <option key={i} value={w.label}>{w.label}</option>
          ))}
        </select>
      </div>
      {/* Responsive Chart */}
      
<div className="w-full h-64 sm:h-80 lg:h-96">
  <ResponsiveContainer width="100%" height="100%">
    <LineChart 
      data={weekData} 
      margin={{ top: 20, right: 20, left: 10, bottom: 40 }}
    >
      <CartesianGrid vertical={true} horizontal={false} stroke="#E5E7EB" />
      <XAxis
        dataKey="date"
        stroke="currentColor"
        interval="preserveStart"
        angle={-35}
        textAnchor="end"
        height={60}
      />
      <YAxis
        domain={[1, 5]}
        ticks={[1, 2, 3, 4, 5]}
        stroke="currentColor"
        width={60}
      />
      <Tooltip />
      <Line
        type="monotone"
        dataKey="mood"
        stroke="#3B82F6"
        strokeWidth={2}
        dot={{ r: 4, fill: "#3B82F6" }}
        activeDot={{ r: 6, stroke: "#6366F1" }}
        connectNulls
      />
    </LineChart>
  </ResponsiveContainer>
</div>

    </div>
  );
}

export default EmojiProgress;
