"use client"
import { useState, useEffect } from "react"
import { ActionCardData, ActionStep } from "@/types"

interface ActionCardProps {
  data?: ActionCardData
}

export default function ActionCard({ data: propData }: ActionCardProps) {
  const [data, setData] = useState<ActionCardData | null>(propData || null)
  const [loading, setLoading] = useState(!propData)
  const [error, _setError] = useState<string | null>(null)
  const [completedTasks, setCompletedTasks] = useState<boolean[]>([])
  const [showModal, setShowModal] = useState(false)
  console.log('data:', data)

  const toggleTask = (index: number) => {
    const newCompleted = [...completedTasks]
    newCompleted[index] = !newCompleted[index]
    setCompletedTasks(newCompleted)
  }

  const openTool = (url: string) => {
    window.open(url, "_blank")
  }

  useEffect(() => {
    if (propData) {
      setData(propData)
      setLoading(false)
      const stepsLength = Array.isArray(propData.steps) ? propData.steps.length : 0
      setCompletedTasks((prev) => {
        if (prev.length === stepsLength) return prev
        return Array.from({ length: stepsLength }, (_, i) => prev[i] ?? false)
      })
    }
  }, [propData])

  const renderStepText = (step: ActionStep): string => {
    if (typeof step === "string") return step
    if (step == null) return ""
    if (typeof step === "object") {
      if ("step" in step && typeof step.step === "string") return step.step
      if ("text" in step && typeof step.text === "string") return step.text
      if ("description" in step && typeof step.description === "string") return step.description
      return JSON.stringify(step)
    }
    return String(step)
  }

  if (loading) {
    return (
      <div className="w-full max-w-md mx-auto p-4">
        <div className="animate-pulse bg-gray-200 h-8 rounded mb-4"></div>
        <div className="animate-pulse bg-gray-200 h-32 rounded"></div>
      </div>
    )
  }

  if (error || !data) {
    return (
      <div className="w-full max-w-md mx-auto p-4">
        <div className="bg-red-50 border border-red-200 rounded-lg p-4">
          <h3 className="text-red-800 font-medium mb-2">Connection Error</h3>
          <p className="text-red-600 text-sm mb-4">{error || "Failed to load action card data"}</p>
          <button
            onClick={() => window.location.reload()}
            className="px-4 py-2 bg-red-600 text-white rounded hover:bg-red-700 transition-colors"
          >
            Try Again
          </button>
        </div>
      </div>
    )
  }

  return (
    <div className=" max-w-xl mx-auto space-y-4">
      {/* Header */}
      <div className="bg-gradient-to-r from-[#132A4F] to-[#1E3A70] text-white rounded-t-xl p-5 md:p-6 shadow-md mt-6">
        <div className="flex flex-col md:flex-row items-start md:items-center justify-between">
          <h1 className="text-2xl md:text-3xl font-bold mb-3 md:mb-0">{data.title}</h1>
          <span className="px-4 py-2 bg-white/20 backdrop-blur-sm rounded-full text-sm font-medium">Action Item</span>
        </div>
      </div>

      {/* Main Card */}
      <div className="border-2 border-teal-200 rounded-lg p-4 bg-white">
        <p className="text-sm text-gray-600 mb-4">{data.description}</p>

        <div className="space-y-3">
          {data.steps.map((step, index) => (
            <div key={index} className="flex items-start space-x-3">
              <input
                type="checkbox"
                checked={completedTasks[index]}
                onChange={() => toggleTask(index)}
                className="mt-1 w-4 h-4 text-teal-600 border-2 border-teal-300 rounded focus:ring-teal-500"
              />
              <span className={`text-md ${completedTasks[index] ? "line-through text-gray-400" : "text-gray-700"}`}>
                {renderStepText(step)}
              </span>
            </div>
          ))}
        </div>

        <div className="mt-4 pt-4 border-t border-gray-200">
          <button
            onClick={() => setShowModal(true)}
            className="w-full px-4 py-2 bg-teal-600 text-white rounded-lg hover:bg-teal-700 transition-colors"
          >
            Start
          </button>
        </div>
      </div>

      {/* Warning Section */}
      <div className="bg-orange-400 text-white p-4 rounded-lg">
        <div className="flex items-start space-x-2">
          <p className="text-sm font-medium">{data.ifWorse}</p>
        </div>
      </div>

      {/* Disclaimer */}
      <p className="text-xs text-gray-500 text-center">{data.disclaimer}</p>

      {showModal && (
        <div className="fixed inset-0 bg-black/50 backdrop-blur-sm flex items-center justify-center z-50">
          <div className="bg-white rounded-lg p-6 w-full max-w-sm mx-4 shadow-xl">
            <div className="flex items-center justify-between mb-4">
              <h3 className="text-lg font-medium">Mini Tools</h3>
              <button
                onClick={() => setShowModal(false)}
                className="text-gray-400 hover:text-gray-600 w-6 h-6 flex items-center justify-between"
              >
                ✕
              </button>
            </div>

            <div className="space-y-3">
              {data.miniTools?.map((tool, index) => (
                <div
                  key={index}
                  className="flex items-center justify-between p-3 border border-gray-200 rounded-lg hover:bg-gray-50 transition-colors"
                >
                  <span className="text-sm font-medium">{tool.title}</span>

                  <button
                    onClick={() => openTool(tool.url)}
                    className="w-8 h-8 bg-teal-600 text-white rounded-full flex items-center justify-center hover:bg-teal-700 transition-colors"
                  >
                    ▶
                  </button>
                </div>
              ))}
            </div>
          </div>
        </div>
      )}
    </div>
  )
}