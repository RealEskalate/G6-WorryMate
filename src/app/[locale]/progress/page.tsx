"use client";
import React, { Suspense, useEffect, useState } from "react";
import RecentEntires from "../_components/RecentEntires";
import { PageHeader } from "@/components/PageHeader";
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import { TrendingUp, Calendar, BookOpen, Target, Award } from "lucide-react";
import { db, DailyEmoji, CheckIn, JournalEntry } from "@/app/lib/db";
import { liveQuery } from "dexie";

function formatDateOnly(date: Date): string {
  return date.toISOString().split("T")[0];
}

const emojiLevels: Record<string, number> = {
  "😞": 1,
  "😐": 2,
  "😊": 3,
  "😄": 4,
  "😍": 5,
};

function computeStreak(checkins: CheckIn[]): number {
  const dateSet = new Set(
    checkins.map((c) => formatDateOnly(new Date(c.date)))
  );
  let streak = 0;
  const day = new Date();
  while (dateSet.has(formatDateOnly(day))) {
    streak += 1;
    day.setDate(day.getDate() - 1);
  }
  return streak;
}

function countCheckinsThisMonth(checkins: CheckIn[]): number {
  const now = new Date();
  const y = now.getFullYear();
  const m = now.getMonth();
  return checkins.filter((c) => {
    const d = new Date(c.date);
    return d.getFullYear() === y && d.getMonth() === m;
  }).length;
}

function countJournalsLast30(journals: JournalEntry[]): number {
  const cutoff = new Date();
  cutoff.setDate(cutoff.getDate() - 30);
  return journals.filter((j) => new Date(j.date) >= cutoff).length;
}

function computeWellnessScore(
  emojis: DailyEmoji[],
  checkins: CheckIn[]
): number {
  if (emojis.length === 0 && checkins.length === 0) return 0;

  const cutoff = new Date();
  cutoff.setDate(cutoff.getDate() - 14);
  const recentMood = emojis.filter((e) => new Date(e.date) >= cutoff);
  const avgMood = recentMood.length
    ? recentMood.reduce((sum, e) => sum + (emojiLevels[e.emoji] || 3), 0) /
      recentMood.length
    : 3;
  const recentChecks = checkins.filter((c) => new Date(c.date) >= cutoff).length;
  const consistency = Math.min(recentChecks / 14, 1);

  const normalizedMood = (avgMood - 1) / 4;
  const score = (normalizedMood * 0.6 + consistency * 0.4) * 100;
  return Math.round(score);
}

export default function ProgressPage() {
  const [streak, setStreak] = useState(0);
  const [monthCheckins, setMonthCheckins] = useState(0);
  const [recentJournals, setRecentJournals] = useState(0);
  const [wellness, setWellness] = useState(0);

  useEffect(() => {
    const sub = liveQuery(async () => {
      const [checkins, journals, emojis] = await Promise.all([
        db.checkin.toArray(),
        db.journals.toArray(),
        db.dailyemoji.toArray(),
      ]);
      return { checkins, journals, emojis };
    }).subscribe({
      next: ({ checkins, journals, emojis }) => {
        setStreak(computeStreak(checkins));
        setMonthCheckins(countCheckinsThisMonth(checkins));
        setRecentJournals(countJournalsLast30(journals));
        setWellness(computeWellnessScore(emojis, checkins));
      },
      error: (err) => {
        console.error("liveQuery error", err);
      },
    });
    return () => sub.unsubscribe();
  }, []);

  const wellnessTip =
    "Increase by logging daily check-ins and choosing positive moods.";

  return (
    <div className="flex flex-col min-h-screen bg-gradient-to-br from-white via-[#F7F9FB] to-white dark:from-[#092B47] dark:via-[#28445C] dark:to-[#092B47] text-[#0D2A4B] dark:text-white">
      <PageHeader title="Your Progress" />

      <div className="p-6 space-y-8 overflow-y-auto">
        {/* Header Section */}
        <div className="text-center space-y-4 max-w-4xl mx-auto">
          <h1 className="text-4xl font-bold text-[#0D2A4B] dark:text-[#10B981]">
            Your Mental Health Journey
          </h1>
          <p className="text-lg text-[#0D2A4B]/70 dark:text-white/80">
            Track your progress&lsquo; celebrate your wins&lsquo; and see how far you&apos;ve come on your wellness journey
          </p>
        </div>

        {/* Stats Overview */}
        <div className="grid grid-cols-1 md:grid-cols-4 gap-6 max-w-6xl mx-auto">
          {/* Day Streak */}
          <Card className="border border-gray-200 shadow-sm bg-white/80 dark:bg-[#28445C] dark:border-[#092B47]">
            <CardContent className="text-center">
              <div className="mx-auto mb-3 h-10 w-10 rounded-full bg-gradient-to-br from-emerald-500 to-emerald-600 flex items-center justify-center">
                <TrendingUp className="h-6 w-6 text-white" />
              </div>
              <div className="text-3xl font-bold text-[#0D2A4B] dark:text-white">{streak}</div>
              <div className="text-sm text-[#0D2A4B]/70 dark:text-white/70">Day Streak</div>
              <div className="text-xs text-indigo-600 dark:text-indigo-400 mt-1">Keep it up</div>
            </CardContent>
          </Card>

          {/* Check-ins */}
          <Card className="border border-gray-200 shadow-sm bg-white/80 dark:bg-[#28445C] dark:border-[#092B47]">
            <CardContent className="text-center">
              <div className="mx-auto mb-3 h-10 w-10 rounded-full bg-gradient-to-br from-emerald-500 to-emerald-600 flex items-center justify-center">
                <Calendar className="h-6 w-6 text-white" />
              </div>
              <div className="text-3xl font-bold text-[#0D2A4B] dark:text-white">{monthCheckins}</div>
              <div className="text-sm text-[#0D2A4B]/70 dark:text-white/70">Check-ins</div>
              <div className="text-xs text-gray-500 dark:text-gray-400 mt-1">This month</div>
            </CardContent>
          </Card>

          {/* Journals */}
          <Card className="border border-gray-200 shadow-sm bg-white/80 dark:bg-[#28445C] dark:border-[#092B47]">
            <CardContent className="text-center">
              <div className="mx-auto mb-3 h-10 w-10 rounded-full bg-gradient-to-br from-emerald-500 to-emerald-600 flex items-center justify-center">
                <BookOpen className="h-6 w-6 text-white" />
              </div>
              <div className="text-3xl font-bold text-[#0D2A4B] dark:text-white">{recentJournals}</div>
              <div className="text-sm text-[#0D2A4B]/70 dark:text-white/70">Journal Entries</div>
              <div className="text-xs text-gray-500 dark:text-gray-400 mt-1">Last 30 days</div>
            </CardContent>
          </Card>

          {/* Wellness Score */}
          <Card className="border border-gray-200 shadow-sm bg-white/80 dark:bg-[#28445C] dark:border-[#092B47]">
            <CardContent className="text-center">
              <div className="mx-auto mb-3 h-10 w-10 rounded-full bg-gradient-to-br from-emerald-500 to-emerald-600 flex items-center justify-center">
                <Award className="h-6 w-6 text-white" />
              </div>
              <div className="text-3xl font-bold text-[#0D2A4B] dark:text-[#10B981]" title={wellnessTip}>
                {wellness}%
              </div>
              <div className="text-sm text-[#0D2A4B]/70 dark:text-white/70" title={wellnessTip}>
                Wellness Score
              </div>
              <div className="text-xs text-gray-500 dark:text-gray-400 mt-1">
                Mood + habit consistency
              </div>
            </CardContent>
          </Card>
        </div>

        {/* Recent Journal Entries */}
        <div className="max-w-5xl mx-auto">
          <Card className="border-0 shadow-xl bg-white/80 dark:bg-[#28445C]/80 backdrop-blur-sm h-fit">
            <CardHeader>
              <CardTitle className="flex items-center gap-2 text-2xl text-[#0D2A4B] dark:text-[#10B981]">
                <BookOpen className="h-6 w-6 text-emerald-500" />
                Recent Entries
              </CardTitle>
              <CardDescription className="text-[#0D2A4B]/70 dark:text-white/70">
                Your latest thoughts and reflections
              </CardDescription>
            </CardHeader>
            <CardContent>
              <Suspense
                fallback={
                  <div className="flex items-center justify-center h-32">
                    <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-emerald-600"></div>
                  </div>
                }
              >
                <RecentEntires />
              </Suspense>
            </CardContent>
          </Card>
        </div>

        {/* Motivational Section */}
        <div className="max-w-4xl mx-auto">
          <Card className="border-0 shadow-xl bg-gradient-to-r from-[#F7F9FB] via-white to-[#F7F9FB] dark:from-[#092B47]/20 dark:via-[#28445C]/20 dark:to-[#092B47]/20">
            <CardContent className="p-8 text-center">
              <div className="space-y-4">
                <div className="w-16 h-16 bg-gradient-to-r from-emerald-500 to-emerald-600 rounded-full flex items-center justify-center mx-auto">
                  <Target className="h-8 w-8 text-white" />
                </div>
                <h3 className="text-2xl font-bold text-[#0D2A4B] dark:text-white">
                  You&apos;re Making Great Progress
                </h3>
                <p className="text-lg text-[#0D2A4B]/70 dark:text-white/70 max-w-2xl mx-auto">
                  Every check-in&lsquo; every journal entry and every moment of self-reflection is a step forward in your mental health journey
                </p>
                <div className="flex justify-center gap-4 mt-6">
                  <div className="px-4 py-2 text-sm border border-gray-300 dark:border-gray-600 rounded-full text-[#0D2A4B] dark:text-white">
                    {streak}-day streak
                  </div>
                  <div className="px-4 py-2 text-sm border border-gray-300 dark:border-gray-600 rounded-full text-[#0D2A4B] dark:text-white">
                    {wellness}% wellness score
                  </div>
                  <div className="px-4 py-2 text-sm border border-gray-300 dark:border-gray-600 rounded-full text-[#0D2A4B] dark:text-white">
                    {monthCheckins} check-ins
                  </div>
                </div>
              </div>
            </CardContent>
          </Card>
        </div>
      </div>
    </div>
  );
}
