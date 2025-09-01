"use client";
import React from "react";
import InfoBox from "./ui/InfoBox";
import DisplayInfo from "./ui/DisplayInfo";
import ContactCard from "./crisis-card/contactCard";
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import { useState, useEffect } from "react";

function useSafetyPlan() {
  const [data, setData] = useState<any>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const fetchData = async () => {
      try {
        const res = await fetch("/api/resources");
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
  }, []);

  return { data, loading, error };
}

const CrisisCard = () => {
  const { data, loading, error } = useSafetyPlan();

  if (loading) return <p className="text-gray-500">Loading...</p>;
  if (error) return <p className="text-red-500">Error: {error}</p>;

  // Extract data from the "resources: " key structure
  const resourcesData = data?.["resources: "] || data?.resources || data;
  const region = resourcesData?.region;
  const resources = resourcesData?.resources || [];
  const safetyPlan = resourcesData?.safety_plan || [];

  return (
    <div className="min-h-screen flex flex-col items-center justify-center  py-4 px-1">
      <div className="w-full max-w-md lg:max-w-2xl xl:max-w-4xl bg-white rounded-2xl shadow-lg p-4 lg:p-6 border border-red-100 relative">
        {/* Fast Exit Button */}

        <h2 className="text-lg lg:text-2xl font-extrabold text-red-700 mb-1 text-center drop-shadow">
          Crisis Support
        </h2>
        <p className="text-gray-700 mb-3 text-center text-base lg:text-lg">
          If you're feeling overwhelmed, unsafe, or struggling with thoughts of
          harm, you're not alone.
          <br />
          <span className="text-red-600 font-semibold">
            Support is available
          </span>
          , and reaching out can make a difference.
        </p>

        {region && (
          <p className="text-sm lg:text-base text-gray-600 text-center mb-3">
            Region: {region}
          </p>
        )}

        <h3 className="text-base lg:text-lg font-bold text-red-600 mb-2 mt-2">
          Immediate Steps
        </h3>
        <div className="space-y-2 mb-4 lg:grid lg:grid-cols-2 lg:gap-4">
          {safetyPlan.map((step: any) => (
            <div
              key={step.step}
              className="p-2 lg:p-3 rounded-lg border border-red-100 bg-red-50 shadow-sm flex flex-col gap-0.5"
            >
              <p className="font-semibold text-red-700 text-sm lg:text-base">
                Step {step.step}
              </p>
              <p className="text-gray-700 text-xs lg:text-sm">{step.instruction}</p>
            </div>
          ))}
        </div>

        <h3 className="text-base lg:text-lg font-bold text-red-600 mb-2 mt-4">
          Resources
        </h3>
        <div className="flex flex-col gap-2 lg:grid lg:grid-cols-2 lg:gap-4">
          {resources.map((res: any, index: number) => (
            <ContactCard
              key={index}
              name={res.name}
              phone={res.contact?.phone || undefined}
              email={res.contact?.email || undefined}
              website={res.contact?.website || undefined}
              availability={res.contact?.availability || undefined}
            />
          ))}
        </div>
        <button
          onClick={() => {
            window.location.href = "/vent";
          }}
          className="flex justify-center cursor-pointer items-center w-1/2 mx-auto mt-5 bg-red-600 hover:bg-red-700 text-white font-bold py-2 px-5 rounded-md shadow transition-colors z-10 text-sm tracking-wide"
          aria-label="Exit"
        >
          Exit
        </button>
      </div>
    </div>
  );
};

export default CrisisCard; 
