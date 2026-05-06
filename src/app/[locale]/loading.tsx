export default function Loading() {
  return (
    <div className="flex items-center justify-center h-screen bg-white dark:bg-[#092B47]">
      <div className="flex flex-col items-center gap-4">
      
        <div className="animate-spin rounded-full h-16 w-16 border-t-4 border-[#0D2A4B] dark:border-[#10B981]" />

  
        <p className="text-lg font-medium text-[#0D2A4B] dark:text-[#10B981] font-['Inter','Noto_Sans_Ethiopic']">
          Loading...
        </p>
      </div>
    </div>
  );
}
