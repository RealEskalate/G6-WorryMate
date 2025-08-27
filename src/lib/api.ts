import { ActionCardData } from '@/types';

const API_BASE_URL = process.env.NEXT_PUBLIC_API_BASE_URL || 'http://localhost:3001/api';

export async function fetchActionCard(cardKey: string): Promise<ActionCardData> {
  const mockResponse: Record<string, ActionCardData> = {
    exam_stress: {
      title: "Exam Stress Relief",
      description: "Let's break this down into manageable steps.",
      steps: [
        "Try a 25-minute focused study session (Pomodoro technique)",
        "Block social media apps during study time",
        "Write down your top 3 priorities for tomorrow",
        "Take 5 deep breaths when you feel overwhelmed",
      ],
      miniTools: ["breathing_exercise", "grounding_5432"],
      ifWorse: "If panic sets in, try the grounding exercise or reach out to a trusted friend.",
      disclaimer: "This is general wellbeing information, not medical or mental health advice.",
    },
  };

  try {
    const response = await fetch(`${API_BASE_URL}/action-cards/${cardKey}`);
    if (!response.ok) {
      throw new Error(`Failed to fetch action card: ${response.status}`);
    }
    return await response.json();
  } catch (error) {
    console.warn('API fetch failed, returning mock response:', error);
    return mockResponse[cardKey]; // fallback to mock
  }
}
