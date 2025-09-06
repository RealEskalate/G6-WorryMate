import { FeaturesSectionDemo } from "@/components/FeatureSection";
import Hero from "@/components/Hero";
import { SparklesPreview } from "@/components/SparklesPreview";
import VentImage from "@/components/VentImage";
import { MarqueeDemo } from "@/components/ReviewsSection";
import React from "react";
import { BlurFade } from "@/components/magicui/blur-fade";
import Footer from "@/components/Footer";
export default function Home() {
  return (
    <div>
      <Hero />
      <BlurFade delay={0.5}>
        <VentImage />

      </BlurFade>
      <div>
        <SparklesPreview tittle="A Variety of Features" />
        <BlurFade delay={0.5}>

          <FeaturesSectionDemo />
        </BlurFade>
      </div>
      <div className="mb-16">

        <MarqueeDemo />
      </div>
      <Footer />
    </div>
  );
}
