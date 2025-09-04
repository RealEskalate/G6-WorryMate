import InfiniteMovingCards from "../../components/ui/infinite-moving-cards";
import { features } from '../lib/features'

export default function Features() {
  return (
    <div className="w-full py-6">
      <h2 className="text-xl md:text-2xl font-semibold mb-4 text-[#0D2A4B]">
        Features
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
