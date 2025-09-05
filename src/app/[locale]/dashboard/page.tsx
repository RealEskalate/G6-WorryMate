import React from "react";
import HowFeel from "../_components/HowFeel";
import EmojiProgress from "../_components/EmojiPorgress";
import DailyCheck from "../_components/DailyCheck";
import RecentEntires from "../_components/RecentEntires";
import Features from "../_components/Features";
import { PageHeader } from "@/components/PageHeader";


function Page() {
  return (
    <div className="flex flex-col bg-white dark:bg-gray-900 min-h-screen">
      <PageHeader title="Dashboard" />
      <div className="p-6 gap-8 overflow-y-auto">

        <div className="flex flex-col md:flex-row gap-8">

          <div className="w-full md:w-3/4 pt-10 bg-white dark:bg-gray-800 shadow-md rounded-lg flex flex-col items-center gap-6">
            <HowFeel />
            <EmojiProgress />
          </div>

          <div className="hidden md:flex w-1/3 bg-white dark:bg-gray-800 shadow-md rounded-lg p-6 flex-col gap-6">
            <DailyCheck />
            <RecentEntires />
          </div>
        </div>


        <div className="w-full flex justify-center items-center bg-[#F7F9FB] dark:bg-gray-800 rounded-[10px] p-4">
          <Features />
        </div>
      </div>
    </div>
  );
}

export default Page;
