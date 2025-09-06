"use client";

import React, { useEffect, useState } from "react";
import ContactCard from "./crisis-card/contactCard";
import type {
    CrisisCardData,
    CrisisResource,
    CrisisSafetyStep,
} from "@/types";

const CrisisCard: React.FC = () => {
    const [data, setData] = useState<CrisisCardData | null>(null);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState<string | null>(null);

    useEffect(() => {
        let cancelled = false;
        const run = async () => {
            try {
                const res = await fetch("/api/crisis-card", { method: "POST" });
                const json = await res.json();
                if (!res.ok) throw new Error(String(json?.message || "Failed to fetch"));
                if (!cancelled) setData(json as CrisisCardData);
            } catch (e) {
                if (!cancelled) setError(e instanceof Error ? e.message : String(e));
            } finally {
                if (!cancelled) setLoading(false);
            }
        };
        run();
        return () => {
            cancelled = true;
        };
    }, []);

    if (loading) return <div className="p-4 bg-white rounded-lg shadow">Loading…</div>;
    if (error) return <div className="p-4 bg-red-50 text-red-700 rounded-lg">Error: {error}</div>;
    if (!data) return null;

    const resources: CrisisResource[] = Array.isArray(data.resources) ? data.resources : [];
    const steps: CrisisSafetyStep[] = Array.isArray(data.safety_plan) ? data.safety_plan : [];

    return (
        <div className="w-full max-w-2xl bg-white rounded-xl shadow border p-4 md:p-6">
            <h2 className="text-xl md:text-2xl font-bold text-red-700 mb-2 text-center">Crisis Support</h2>
            {data.region && (
                <p className="text-sm text-gray-600 text-center mb-4">Region: {data.region}</p>
            )}

            {steps.length > 0 && (
                <div className="mb-4">
                    <h3 className="text-lg font-semibold text-red-600 mb-2">Immediate Steps</h3>
                    <div className="grid grid-cols-1 md:grid-cols-2 gap-2">
                        {steps.map((s, i) => (
                            <div key={`${s.step ?? i}`} className="p-3 border rounded-lg bg-red-50 border-red-100">
                                <p className="text-sm font-medium text-red-700">Step {String(s.step ?? i + 1)}</p>
                                <p className="text-sm text-gray-700">{String(s.instruction ?? "")}</p>
                            </div>
                        ))}
                    </div>
                </div>
            )}

            {resources.length > 0 && (
                <div className="mt-4">
                    <h3 className="text-lg font-semibold text-red-600 mb-2">Resources</h3>
                    <div className="grid grid-cols-1 md:grid-cols-2 gap-3">
                        {resources.map((r, idx) => (
                            <ContactCard
                                key={idx}
                                name={r.name ?? "Resource"}
                                phone={r.contact?.phone}
                                email={r.contact?.email}
                                website={r.contact?.website}
                                availability={r.contact?.availability}
                            />
                        ))}
                    </div>
                </div>
            )}

            {data.disclaimer && (
                <p className="mt-4 text-xs text-gray-500 text-center">{data.disclaimer}</p>
            )}
        </div>
    );
};

export default CrisisCard;
// "use client";
// import React from "react";
// import InfoBox from "./InfoBox";
// import DisplayInfo from "./DisplayInfo";
// import ContactCard from "./crisis-card/contactCard";
// import {
//   Card,
//   CardContent,
//   CardDescription,
//   CardHeader,
//   CardTitle,
// } from "@/components/ui/card";
// import { useState, useEffect } from "react";

// type SafetyPlanResource = {
//   name?: string;
//   contact?: {
//     phone?: string;
//     email?: string;
//     website?: string;
//     availability?: string;
//   };
// };

// type SafetyPlanStep = {
//   step?: string | number;
//   instruction?: string;
// };

// type SafetyPlanData = {
//   region?: string;
//   resources?: SafetyPlanResource[];
//   safety_plan?: SafetyPlanStep[];
//   [key: string]: unknown;
// };

// function useSafetyPlan() {
//   const [data, setData] = useState<SafetyPlanData | null>(null);
//   const [loading, setLoading] = useState(true);
//   const [error, setError] = useState<string | null>(null);

//   useEffect(() => {
//     const fetchData = async () => {
//       try {
//         const res = await fetch("/api/crisis-card");
//         if (!res.ok) throw new Error("Failed to fetch");
//         const json = await res.json();
//         setData(json);
//       } catch (err) {
//         setError(
//           typeof err === 'object' && err !== null && 'message' in err
//             ? String((err as { message?: unknown }).message)
//             : String(err)
//         );
//       } finally {
//         setLoading(false);
//       }
//     };
//     fetchData();
//   }, []);

//   return { data, loading, error };
// }

// const CrisisCard = () => {
//   const { data, loading, error } = useSafetyPlan();

//   if (loading) return <p className="text-gray-500">Loading...</p>;
//   if (error) return <p className="text-red-500">Error: {error}</p>;

//   // Extract data from the "resources: " key structure
//   const resourcesData: SafetyPlanData = (typeof data === 'object' && data !== null ? data : {}) as SafetyPlanData;
//   const region = resourcesData.region;
//   const resources: SafetyPlanResource[] = Array.isArray(resourcesData.resources) ? resourcesData.resources : [];
//   const safetyPlan: SafetyPlanStep[] = Array.isArray(resourcesData.safety_plan) ? resourcesData.safety_plan : [];

//   return (
//     <div className="min-h-screen flex flex-col items-center justify-center  py-4 px-1">
//       <div className="w-full max-w-md lg:max-w-2xl xl:max-w-4xl bg-white rounded-2xl shadow-lg p-4 lg:p-6 border border-red-100 relative">
//         {/* Fast Exit Button */}

//         <h2 className="text-lg lg:text-2xl font-extrabold text-red-700 mb-1 text-center drop-shadow">
//           Crisis Support
//         </h2>
//         <p className="text-gray-700 mb-3 text-center text-base lg:text-lg">
//           If you&apos;re feeling overwhelmed, unsafe, or struggling with thoughts of
//           harm, you&apos;re not alone.
//           <br />
//           <span className="text-red-600 font-semibold">
//             Support is available
//           </span>
//           , and reaching out can make a difference.
//         </p>

//         {region && (
//           <p className="text-sm lg:text-base text-gray-600 text-center mb-3">
//             Region: {region}
//           </p>
//         )}

//         <h3 className="text-base lg:text-lg font-bold text-red-600 mb-2 mt-2">
//           Immediate Steps
//         </h3>
//         <div className="space-y-2 mb-4 lg:grid lg:grid-cols-2 lg:gap-4">
//           {safetyPlan.map((step, idx) => (
//             <div
//               key={String(step.step ?? idx)}
//               className="p-2 lg:p-3 rounded-lg border border-red-100 bg-red-50 shadow-sm flex flex-col gap-0.5"
//             >
//               <p className="font-semibold text-red-700 text-sm lg:text-base">
//                 Step {String(step.step ?? idx)}
//               </p>
//               <p className="text-gray-700 text-xs lg:text-sm">{String(step.instruction ?? '')}</p>
//             </div>
//           ))}
//         </div>

//         <h3 className="text-base lg:text-lg font-bold text-red-600 mb-2 mt-4">
//           Resources
//         </h3>
//         <div className="flex flex-col gap-2 lg:grid lg:grid-cols-2 lg:gap-4">
//           {resources.map((res, index: number) => (
//             <ContactCard
//               key={index}
//               name={res.name ?? ''}
//               phone={res.contact?.phone ?? undefined}
//               email={res.contact?.email ?? undefined}
//               website={res.contact?.website ?? undefined}
//               availability={res.contact?.availability ?? undefined}
//             />
//           ))}
//         </div>
//         <button
//           onClick={() => {
//             window.location.href = "/vent";
//           }}
//           className="flex justify-center cursor-pointer items-center w-1/2 mx-auto mt-5 bg-red-600 hover:bg-red-700 text-white font-bold py-2 px-5 rounded-md shadow transition-colors z-10 text-sm tracking-wide"
//           aria-label="Exit"
//         >
//           Exit
//         </button>
//       </div>
//     </div>
//   );
// };

// export default CrisisCard; 
