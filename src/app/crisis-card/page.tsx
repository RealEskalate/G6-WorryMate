"use client";
import React from "react";
import InfoBox from "../components/ui/InfoBox";
import DisplayInfo from "../components/ui/DisplayInfo";
import ContactCard from "../components/crisis-card/contactCard";
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import { useState, useEffect } from "react";

function useSafetyPlan(url: string) {
  const [data, setData] = useState<any>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const fetchData = async () => {
      try {
        const res = await fetch(url);
        if (!res.ok) throw new Error("Failed to fetch");
        const json = await res.json();
        setData(json);
      } catch (err: any) {
        setError(err.message);
      } finally {
        setLoading(false);
      }
    };
    fetchData();
  }, [url]);

  return { data, loading, error };
}
const page = () => {
  const { data, loading, error } = useSafetyPlan(
    "https://g6-worrymate-zt0r.onrender.com/resources?region=ET"
  );

  if (loading) return <p className="text-gray-500">Loading...</p>;
  if (error) return <p className="text-red-500">Error: {error}</p>;
  return (
    <div className="min-h-screen flex flex-col items-center justify-center bg-black py-4 px-1">
      <div className="w-full max-w-md bg-white rounded-2xl shadow-lg p-4 border border-red-100 relative">
        {/* Fast Exit Button */}
        <button
          onClick={() => {
            window.location.href = "https://www.google.com";
          }}
          className="absolute top-3 right-3 bg-red-600 hover:bg-red-700 text-white font-bold py-2 px-5 rounded-md shadow transition-colors z-10 text-sm tracking-wide"
          aria-label="Fast Exit"
        >
          Fast Exit
        </button>
        <h2 className="text-lg font-extrabold text-red-700 mb-1 text-center drop-shadow">
          Crisis Support
        </h2>
        <p className="text-gray-700 mb-3 text-center text-base">
          If you’re feeling overwhelmed, unsafe, or struggling with thoughts of
          harm, you’re not alone.
          <br />
          <span className="text-red-600 font-semibold">
            Support is available
          </span>
          , and reaching out can make a difference.
        </p>

        <h3 className="text-base font-bold text-red-600 mb-2 mt-2">
          Immediate Steps
        </h3>
        <div className="space-y-2 mb-4">
          {data.safety_plan.map((step: any) => (
            <div
              key={step.step}
              className="p-2 rounded-lg border border-red-100 bg-red-50 shadow-sm flex flex-col gap-0.5"
            >
              <p className="font-semibold text-red-700 text-sm">
                Step {step.step}
              </p>
              <p className="text-gray-700 text-xs">{step.instruction}</p>
            </div>
          ))}
        </div>

        <h3 className="text-base font-bold text-red-600 mb-2 mt-4">
          Resources
        </h3>
        <div className="flex flex-col gap-2">
          {data.resources.map((res: any, index: number) => (
            <ContactCard
              key={index}
              name={res.name}
              phone={res.contact?.phone || res.phone || undefined}
              email={res.contact?.email || res.email || undefined}
              website={res.contact?.website || res.website || undefined}
              availability={
                res.contact?.availability || res.availability || undefined
              }
            />
          ))}
        </div>
      </div>
    </div>
  );
};
export default page;
