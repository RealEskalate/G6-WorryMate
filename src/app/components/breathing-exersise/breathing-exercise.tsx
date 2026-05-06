"use client"

import { useState, useEffect, useRef } from "react"

type Phase = "inhale" | "exhale" | "pause"

export default function BreathingExercise() {
  const [duration, setDuration] = useState(4)
  const [isActive, setIsActive] = useState(false)
  const [currentPhase, setCurrentPhase] = useState<Phase>("pause")
  const [cycleCount, setCycleCount] = useState(0)
  const [timeLeft, setTimeLeft] = useState(0)
  const intervalRef = useRef<NodeJS.Timeout | null>(null)

  const totalCycles = 3

  useEffect(() => {
    if (isActive && cycleCount < totalCycles) {
      if (currentPhase === "pause") {
        setCurrentPhase("inhale")
        setTimeLeft(duration)
      }
    } else if (cycleCount >= totalCycles) {
      setIsActive(false)
      setCurrentPhase("pause")
    }
  }, [isActive, cycleCount, duration, currentPhase])

  useEffect(() => {
    if (isActive && timeLeft > 0) {
      intervalRef.current = setTimeout(() => {
        setTimeLeft(timeLeft - 1)
      }, 1000)
    } else if (isActive && timeLeft === 0) {
      if (currentPhase === "inhale") {
        setCurrentPhase("exhale")
        setTimeLeft(duration)
      } else if (currentPhase === "exhale") {
        setCycleCount((prev) => prev + 1)
        setCurrentPhase("inhale")
        setTimeLeft(duration)
      }
    }

    return () => {
      if (intervalRef.current) {
        clearTimeout(intervalRef.current)
      }
    }
  }, [isActive, timeLeft, currentPhase, duration])

  const handleStart = () => {
    setIsActive(true)
    setCycleCount(0)
    setCurrentPhase("pause")
  }

  const handleReset = () => {
    setIsActive(false)
    setCurrentPhase("pause")
    setCycleCount(0)
    setTimeLeft(0)
    if (intervalRef.current) {
      clearTimeout(intervalRef.current)
    }
  }

  const getHeartScale = () => {
    if (currentPhase === "inhale") {
      return 1 + (duration - timeLeft) * 0.1
    } else if (currentPhase === "exhale") {
      return 1.4 - (duration - timeLeft) * 0.1
    }
    return 1
  }

  const getPhaseText = () => {
    switch (currentPhase) {
      case "inhale":
        return "Breathe In"
      case "exhale":
        return "Breathe Out"
      default:
        return "Ready to breathe"
    }
  }

  return (
    <div className="min-h-screen bg-gray-100 flex items-center justify-center p-4">
      <div className="bg-white rounded-2xl shadow-lg p-8 w-full max-w-sm mx-auto text-center space-y-6">
        <h1 className="text-2xl font-bold text-gray-800 mb-8">Breathing Exercise</h1>

        <div className="flex items-center justify-center h-24 mb-6">
          <div
            className="transition-transform duration-1000 ease-in-out"
            style={{
              transform: `scale(${getHeartScale()})`,
            }}
          >
            <svg width="80" height="80" viewBox="0 0 24 24" fill="none">
              <path
                d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"
                fill="#132A4F"
              />
            </svg>
          </div>
        </div>

        <div className="text-lg font-medium text-gray-700 mb-8">{getPhaseText()}</div>

        <div className="space-y-4 mb-8">
          <div className="text-sm font-medium text-gray-600">Breathing Duration: {duration} seconds</div>
          <div className="relative">
            <input
              type="range"
              min="3"
              max="10"
              value={duration}
              onChange={(e) => setDuration(Number.parseInt(e.target.value))}
              disabled={isActive}
              className="w-full h-2 bg-gray-200 rounded-lg appearance-none cursor-pointer slider"
            />
            <div className="flex justify-between text-xs text-gray-500 mt-1">
              <span>3s</span>
              <span>10s</span>
            </div>
          </div>
        </div>

        <div className="flex gap-3 justify-center">
          <button
            onClick={handleStart}
            disabled={isActive}
            className="px-6 py-2.5 text-white rounded-lg font-medium disabled:opacity-50 disabled:cursor-not-allowed transition-colors flex items-center gap-2"
            style={{ backgroundColor: "#132A4F" }}
            onMouseEnter={(e) => !isActive && (e.currentTarget.style.backgroundColor = "#0f1f3a")}
            onMouseLeave={(e) => !isActive && (e.currentTarget.style.backgroundColor = "#132A4F")}
          >
            <svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor">
              <path d="M8 5v14l11-7z" />
            </svg>
            Start
          </button>
          <button
            onClick={handleReset}
            className="px-6 py-2.5 bg-gray-200 text-gray-700 rounded-lg font-medium hover:bg-gray-300 transition-colors flex items-center gap-2"
          >
            <svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor">
              <path d="M3 12a9 9 0 0 1 9-9 9.75 9.75 0 0 1 6.74 2.74L21 8" />
              <path d="M21 3v5h-5" />
              <path d="M21 12a9 9 0 0 1-9 9 9.75 9.75 0 0 1-6.74-2.74L3 16" />
              <path d="M3 21v-5h5" />
            </svg>
            Reset
          </button>
        </div>

        {isActive && (
          <div className="space-y-2 mt-6">
            <div className="text-3xl font-bold tabular-nums" style={{ color: "#132A4F" }}>
              {timeLeft}
            </div>
            <div className="text-sm text-gray-500">
              Cycle {cycleCount + 1} of {totalCycles}
            </div>
          </div>
        )}

        {cycleCount >= totalCycles && !isActive && (
          <div className="bg-green-50 border border-green-200 rounded-lg p-4 mt-6">
            <div className="text-lg font-semibold text-green-700">Well Done!</div>
            <p className="text-sm text-green-600 mt-1">You&apos;ve completed your breathing exercise.</p>
          </div>
        )}
      </div>
    </div>
  )
}
