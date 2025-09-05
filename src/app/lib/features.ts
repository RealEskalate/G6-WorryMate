interface FeatureCard {
  title: string;
  description: string;
  image: string; 
  buttonText: string;
  buttonLink: string;
}


export const features: FeatureCard[] = [
  {
    title: "AI Chat",
    description: "Get personalized guidance and answers from our intelligent assistant.",
    image: "/Chatbot.png",
    buttonText: "Chat Now",
    buttonLink: "/vent",
  },
  {
    title: "Write Journal",
    description: "Reflect on your thoughts and emotions with daily journaling.",
    image: "/journal.png",
    buttonText: "Start Writing",
    buttonLink: "/journal",
  },
  {
    title: "Wellness Kits",
    description: "Explore curated resources to support your mental and emotional well-being.",
    image: "/meditation.png",
    buttonText: "Explore Kits",
    buttonLink: "/kits",
  },
  {
    title: "Progress Tracker",
    description: "Visualize your growth and milestones over time.",
    image: "/progress.png",
    buttonText: "Track Progress",
    buttonLink: "/progress",
  },
];
