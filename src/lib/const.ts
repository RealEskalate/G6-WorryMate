import { ActionCardData } from '@/types';

export const LOCAL_ACTION_CARDS: Record<string, ActionCardData> = {
  exam_stress: {
    title: "Exam Stress Relief",
    description: "Let's break this down into manageable steps.",
    steps: [
      "Try a 25-minute focused study session (Pomodoro technique)",
      "Block social media apps during study time",
      "Write down your top 3 priorities for tomorrow",
      "Take 5 deep breaths when you feel overwhelmed"
    ],
    miniTools: ["breathing_exercise", "grounding_54321"],
    ifWorse: "If panic sets in, try the grounding exercise or reach out to a trusted friend.",
    disclaimer: "This is general wellbeing information, not medical or mental health advice."
  },
  // Add more cards as needed
};

export const MINI_TOOLS = {
  breathing_exercise: {
    id: "breathing_exercise",
    name: "Start Breathing",
    icon: "🧘"
  },
  grounding_54321: {
    id: "grounding_54321",
    name: "Try Grounding",
    icon: "🌳"
  }
};