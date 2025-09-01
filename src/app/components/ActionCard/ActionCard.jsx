"use client"
import { useState, useEffect } from "react"
import { fetchActionCardData } from "../../../lib/api"

export default function ActionCard() {
  const [data, setData] = useState(null)
  const [loading, setLoading] = useState(true)
  const [completedTasks, setCompletedTasks] = useState([])

  useEffect(() => {
    const loadData = async () => {
      try {
        const result = await fetchActionCardData()
        setData(result.exam_stress)
        setCompletedTasks(new Array(result.exam_stress.steps.length).fill(false))
      } catch (error) {
        console.error("Error loading data:", error)
      } finally {
        setLoading(false)
      }
    }
    loadData()
  }, [])

  const toggleTask = (index) => {
    const newCompleted = [...completedTasks]
    newCompleted[index] = !newCompleted[index]
    setCompletedTasks(newCompleted)
  }

  if (loading) {
    return <div className="w-full max-w-md mx-auto p-4">Loading...</div>
  }

  if (!data) {
    return <div className="w-full max-w-md mx-auto p-4">Error loading data</div>
  }

  return (
    <div className="w-full max-w-md mx-auto space-y-4">
      {/* Header */}
      <div className="flex items-center justify-between">
        <h2 className="text-lg font-medium">{data.title}</h2>
        <button className="px-3 py-1 bg-blue-50 border border-blue-200 text-blue-700 rounded text-sm">
          Action Item
        </button>
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
              <span className={`text-sm ${completedTasks[index] ? "line-through text-gray-400" : "text-gray-700"}`}>
                {step}
              </span>
            </div>
          ))}
        </div>
      </div>

      {/* Warning Section */}
      <div className="bg-orange-400 text-white p-4 rounded-lg">
        <div className="flex items-start space-x-2">
          <div className="w-6 h-6 bg-black rounded-full flex-shrink-0 mt-0.5"></div>
          <p className="text-sm font-medium">{data.ifWorse}</p>
        </div>
      </div>

      {/* Disclaimer */}
      <p className="text-xs text-gray-500 text-center">{data.disclaimer}</p>
    </div>
  )
}

