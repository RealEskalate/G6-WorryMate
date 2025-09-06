import { features } from "@/app/lib/features";
import InfiniteMovingCards from "@/components/ui/infinite-moving-cards";
import { useTranslations } from "next-intl";

export default function Features() {
  const t = useTranslations('Features');
  return (
    <div className="w-full py-6 ">
      <h2 className="text-xl md:text-2xl font-semibold mb-4 dark:text-[#10B981] text-[#0D2A4B]">
        {t('features')}
      </h2>
      <InfiniteMovingCards
        items={features}
        direction="left"
        speed="normal"
        pauseOnHover
        className="py-4"
      />
    </div>
  );
}
