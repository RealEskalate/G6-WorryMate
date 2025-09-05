"use client"
import { useState, useEffect } from "react"
import { ActionCardData, ActionStep } from "../types"
import Link from "next/link";

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
    <div className=" max-w-xl mx-auto space-y-2 rounded-t-xl p-5 md:p-6 shadow-md mt-6">
      {/* Header */}
      <div className="text-[#132A4F]">
        <div className="flex flex-col md:flex-row items-start md:items-center justify-between">
          <h1 className="text-2xl md:text-3xl font-bold mb-3 md:mb-0">{data.title}</h1>
          
        </div>
      </div>

      {/* Main Card */}
      <div className="text-black">
        <p className="my-4 text-lg">{data.description}</p>

        <div className="space-y-3">
          <h3 className="font-bold  font-bold text-xl text-[#132A4F]">Panic steps:</h3>
          {data.steps.map((step, index) => (
            <div key={index} className="flex items-start space-x-3  ">
              
              <span className="text-green-500">{index + 1}.</span>
              <span className={`text-md text-black ${completedTasks[index] ? "line-through text-black" : "text-black"}`}>{renderStepText(step)}
              </span>
            </div>
          ))}
        </div>

      </div>

      {/* Warning Section */}
      <div className=" ">
        <div className="items-start space-x-2 mt-4">
          <div className="font-bold text-lg text-[#132A4F]">If Worse:</div>
          
          <div className="text-black"><span className="pr-2">•</span>{data.ifWorse}</div>
        </div>
      </div>

      {/* Disclaimer */}
       
      <p className="text-gray-500 text-orange-500">Disclaimer:{data.disclaimer}</p>
      {/* tools */}
      <p className="font-bold text-lg mt-4">Tools:</p>
       <div className="space-y-3 ml-4 mt-[-5px]">
              {data.miniTools?.map((tool, index) => (
                <div>
                  <div
                    key={index}
                    className=""
                  >
                    <span className="font-medium text-lg">{tool.title}</span>

                  
                  </div>
                    <a
                      href={tool.url}
                      target="_blank"
                      rel="noopener noreferrer"
                      className="hover:text-teal-700 transition-colors text-black"
                    >
                      {tool.url}
                    </a>
                  </div>
              ))}
        </div>
         <div className="flex space-x-8 justify-center mt-5 font-medium mt-8">
           <Link href="/box-breathing">
               <button className="bg-gray-200 text-lg text-gray-700 px-8 py-3 rounded-3xl hover:text-[#132A4F] hover:bg-gray-100">Box Breathing</button>
           </Link>
           <Link href="/daily-journal">
               <button className="bg-gray-200 text-lg text-gray-700 px-8 py-3 rounded-4xl hover:text-[#132A4F] hover:bg-gray-100">Daily Journal</button>
           </Link>
        </div>
      </div>
  )
  }

