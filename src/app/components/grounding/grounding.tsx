"use client"

import { useState } from "react"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardHeader } from "@/components/ui/card"
import { ArrowLeft, RotateCcw } from "lucide-react"

const steps = [
  {
    number: 1,
    title: "Look around and name 5 things you can see",
    count: 5,
    sense: "see",
  },
  {
    number: 2,
    title: "Listen carefully and name 4 things you can hear",
    count: 4,
    sense: "hear",
  },
  {
    number: 3,
    title: "Touch and name 3 things you can feel",
    count: 3,
    sense: "feel",
  },
  {
    number: 4,
    title: "Think of 2 things you can smell",
    count: 2,
    sense: "smell",
  },
  {
    number: 5,
    title: "Name 1 thing you can taste",
    count: 1,
    sense: "taste",
  },
]

export function Grounding() {
  const [currentStep, setCurrentStep] = useState(0)
  const [isCompleted, setIsCompleted] = useState(false)

  const handleNext = () => {
    if (currentStep < steps.length - 1) {
      setCurrentStep(currentStep + 1)
    } else {
      setIsCompleted(true)
    }
  }

  const handlePrevious = () => {
    if (currentStep > 0) {
      setCurrentStep(currentStep - 1)
    }
  }

  const handleReset = () => {
    setCurrentStep(0)
    setIsCompleted(false)
  }

  const progressPercentage = ((currentStep + 1) / steps.length) * 100

  if (isCompleted) {
    return (
      <Card className="w-full max-w-md mx-auto bg-white shadow-lg mt-30">
        <CardHeader className="text-center pb-4">
          <div className="flex items-center justify-between mb-4">
            <Button variant="ghost" size="icon" onClick={handleReset}>
              <ArrowLeft className="h-5 w-5" />
            </Button>
            <h1 className="text-lg font-semibold text-gray-800">5-4-3-2-1 Grounding</h1>
            <div className="w-10" />
          </div>
        </CardHeader>

        <CardContent className="text-center py-12">
          <div className="mb-6">
            <div className="w-16 h-16 bg-green-100 rounded-full flex items-center justify-center mx-auto mb-4">
              <svg className="w-8 h-8 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M5 13l4 4L19 7" />
              </svg>
            </div>
            <h2 className="text-xl font-semibold text-gray-800 mb-2">Congratulations!</h2>
            <p className="text-gray-600">You have completed the 5-4-3-2-1 Grounding Exercise</p>
          </div>

          <Button onClick={handleReset} className="w-full bg-slate-800 hover:bg-slate-700 text-white">
            Start Again
          </Button>
        </CardContent>
      </Card>
    )
  }

  return (
    <Card className="w-full max-w-md mx-auto bg-white shadow-lg mt-10">
      <CardHeader className="pb-4">
        <div className="flex items-center justify-between mb-4">
          <Button variant="ghost" size="icon">
            <ArrowLeft className="h-5 w-5" />
          </Button>
          <h1 className="text-lg font-semibold text-gray-800">5-4-3-2-1 Grounding</h1>
          <div className="w-10" />
        </div>

        <div className="space-y-3">
          <div className="flex items-center gap-2">
            <div className="w-6 h-6 bg-slate-800 rounded-full flex items-center justify-center">
              <svg className="w-4 h-4 text-white" fill="currentColor" viewBox="0 0 20 20">
                <path
                  fillRule="evenodd"
                  d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z"
                  clipRule="evenodd"
                />
              </svg>
            </div>
            <span className="text-sm font-medium text-gray-800">5-4-3-2-1 Grounding Exercise</span>
          </div>

          <div className="w-full bg-gray-200 rounded-full h-2">
            <div
              className="bg-slate-800 h-2 rounded-full transition-all duration-300"
              style={{ width: `${progressPercentage}%` }}
            />
          </div>
        </div>
      </CardHeader>

      <CardContent className="space-y-4">
        {steps.map((step, index) => (
          <div
            key={step.number}
            className={`p-4 rounded-lg border-2 transition-all ${
              index === currentStep
                ? "border-slate-800 bg-slate-50"
                : index < currentStep
                  ? "border-green-200 bg-green-50"
                  : "border-gray-200 bg-gray-50"
            }`}
          >
            <div className="flex items-start gap-3">
              <div
                className={`w-8 h-8 rounded-full flex items-center justify-center text-sm font-semibold ${
                  index === currentStep
                    ? "bg-slate-800 text-white"
                    : index < currentStep
                      ? "bg-green-600 text-white"
                      : "bg-gray-300 text-gray-600"
                }`}
              >
                {index < currentStep ? (
                  <svg className="w-4 h-4" fill="currentColor" viewBox="0 0 20 20">
                    <path
                      fillRule="evenodd"
                      d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z"
                      clipRule="evenodd"
                    />
                  </svg>
                ) : (
                  step.number
                )}
              </div>
              <div className="flex-1">
                <p className={`text-sm ${index === currentStep ? "text-gray-800 font-medium" : "text-gray-600"}`}>
                  {step.title}
                </p>
              </div>
            </div>
          </div>
        ))}

        <div className="flex gap-3 pt-4">
          <Button
            variant="outline"
            onClick={handlePrevious}
            disabled={currentStep === 0}
            className="flex-1 bg-transparent"
          >
            Previous
          </Button>

          <Button variant="outline" onClick={handleReset} className="px-4 bg-transparent">
            <RotateCcw className="h-4 w-4" />
            <span className="sr-only">Reset</span>
          </Button>

          <Button onClick={handleNext} className="flex-1 bg-slate-800 hover:bg-slate-700 text-white">
            Next
          </Button>
        </div>
      </CardContent>
    </Card>
  )
}
export default Grounding