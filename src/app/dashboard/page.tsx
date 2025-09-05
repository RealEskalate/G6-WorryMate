import React from "react";
import HowFeel from "../_components/HowFeel";
import EmojiProgress from "../_components/EmojiPorgress";
import DailyCheck from "../_components/DailyCheck";
import RecentEntires from "../_components/RecentEntires";
import Features from "../_components/Features";

function Page() {
  return (
    <div className="flex flex-col bg-white min-h-screen p-6 gap-8 dark:bg-[#04]">

      <div className="flex flex-col md:flex-row gap-8">
   
        <div className="w-full md:w-3/4 pt-10 bg-white shadow-md rounded-lg flex flex-col items-center gap-6">
          <HowFeel />
          <EmojiProgress />
        </div>

        <div className="hidden md:block w-1/3 bg-white shadow-md rounded-lg p-6 flex flex-col gap-6">
          <DailyCheck />
          <RecentEntires />
        </div>
      </div>


      <div className="w-screen flex justify-center items-center relative left-[50px] bg-[#F7F9FB] rounded-[10px] ">
        <Features />
      </div>
    </div>
  );
}

export default Page;
