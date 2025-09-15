import React from "react";
import HowFeel from "../_components/HowFeel";
import EmojiProgress from "../_components/EmojiPorgress";
import DailyCheck from "../_components/DailyCheck";
import RecentEntires from "../_components/RecentEntires";
import Features from "../_components/Features";
import { PageHeader } from "@/components/PageHeader";

function Page() {
  return (
    <div className="flex flex-col bg-white dark:bg-[#092B47] min-h-screen">
      <PageHeader title="Dashboard" />
      <div className="p-2 sm:p-4 gap-4 sm:gap-6 max-w-full w-full">
        <div className="flex flex-col md:flex-row gap-4 sm:gap-6 w-full">
          {/* Left section */}
          <div className="w-full md:w-2/3 bg-white dark:bg-[#28445C] shadow-md rounded-lg p-2 sm:p-4 flex flex-col gap-4">
            <HowFeel />
            <EmojiProgress />
          </div>

          {/* Right section */}
          <div className="w-full md:w-1/3 flex flex-col gap-4">
            <div className="bg-white dark:bg-[#28445C] shadow-md rounded-lg p-2 sm:p-4">
              <DailyCheck />
            </div>
            <div className="bg-white dark:bg-[#28445C] shadow-md rounded-lg p-2 sm:p-4">
              <RecentEntires />
            </div>
          </div>
        </div>

      </div>
    </div>
  );
}

export default Page;
