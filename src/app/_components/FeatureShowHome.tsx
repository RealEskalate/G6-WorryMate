import React from "react";
import { ImagesSlider } from "@/components/ui/images-slider";
import { slides } from "../lib/slides";

function FeatureShowHome() {
  

  return (
    <div className="w-full h-[600px] relative">
      <ImagesSlider
        slides={slides}
        autoplay
        overlay
        overlayClassName="bg-black/50"
        className="rounded-lg"
      />
    </div>
  );
}

export default FeatureShowHome;
