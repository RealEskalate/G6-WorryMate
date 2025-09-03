'use client'
import React, { useEffect, useState } from "react";
import { db, DailyEmoji } from "../lib/db";
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

function moodToWord(emoji: string): string {
  switch (emoji) {
    case "😞": return "Low";
    case "😐": return "Meh";
    case "😊": return "Okay";
    case "😄": return "Good";
    case "😍": return "Great";
    default: return "";
  }
}

function EmojiProgress() {
  const [entries, setEntries] = useState<DailyEmoji[]>([]);
  const [weeks, setWeeks] = useState<{ label: string; start: Date; end: Date }[]>([]);
  const [selectedWeek, setSelectedWeek] = useState<{ start: Date; end: Date, label: string } | null>(null);
  const [weekData, setWeekData] = useState<{ date: string; mood: number | null; mood_label: string | null }[]>([]);

  useEffect(() => {
    async function fetchEmojis() {
      const allEntries: DailyEmoji[] = await db.dailyemoji.toArray();
      setEntries(allEntries);

      if (allEntries.length > 0) {
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


        const today = new Date();
        const currentWeek = generatedWeeks.find(w =>
          isWithinInterval(today, { start: w.start, end: w.end })
        );
        if (currentWeek) setSelectedWeek(currentWeek);
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
  }, [selectedWeek, entries]);

  return (
    <div className="p-4 bg-[#F7F9FB] rounded-[12px] w-[90%] mt-4 ">
      <div className="flex justify-between px-20 py-5">
        <div>
          <h1 className="text-xl font-semibold text-[#0D2A4B]">Mood Tracker</h1>
          <p className="text-gray-600">Track your mood over time</p>
        </div>

        <select
          className="border p-2 rounded mb-4"
          value={selectedWeek ? selectedWeek.label : ""}
          onChange={(e) => {
            const week = weeks.find(w => w.label === e.target.value);
            if (week) setSelectedWeek(week);
          }}
        >
          <option value="">Select a week</option>
          {weeks.map((w, i) => (
            <option key={i} value={w.label}>{w.label}</option>
          ))}
        </select>
      </div>

      <ResponsiveContainer width="100%" height={300}>
        <LineChart data={weekData}>
          <CartesianGrid vertical={true} horizontal={false} stroke="#E5E7EB" />

          <XAxis dataKey="date" />
          <YAxis
            domain={[1, 5]}
            ticks={[1, 2, 3, 4, 5]}
            tickFormatter={(val) => {
              if (val === 1) return "Low";
              if (val === 2) return "Meh";
              if (val === 3) return "Okay";
              if (val === 4) return "Good";
              if (val === 5) return "Great";
              return "";
            }}
          />

          <Tooltip
            formatter={(val: number, _name, props) => {
              const item = weekData[props.payload.index];
              if (!item) return [moodToWord(emojiLevel(val)), "Mood"];
              return [`${item.mood_label} (${val})`, "Mood"];
            }}
            labelFormatter={(label) => `Date: ${label}`}
          />

          <defs>
            <linearGradient id="lineGradient" x1="0" y1="0" x2="0" y2="1">
              <stop offset="0%" stopColor="#6366F1" stopOpacity={0.9} />
              <stop offset="100%" stopColor="#3B82F6" stopOpacity={0.6} />
            </linearGradient>
          </defs>

          <Line
            type="monotone"
            dataKey="mood"
            stroke="url(#lineGradient)"
            strokeWidth={4}
            dot={{ r: 6, fill: "#3B82F6", strokeWidth: 2, stroke: "white" }}
            activeDot={{ r: 8, stroke: "#6366F1", strokeWidth: 2 }}
            connectNulls
          />
        </LineChart>
      </ResponsiveContainer>
    </div>
  );
}

export default EmojiProgress;
