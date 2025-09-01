export const mockRiskCheck = [
  {
    risk: "NONE",
    tags: [],
  },
  {
    risk: "LOW",
    tags: ["stress", "exam"],
  },
  {
    risk: "CRISIS",
    tags: ["self-harm"],
  },
  {
    risk: "CRISIS",
    tags: ["violence", "domestic"],
  },
];

export const mockMapIntent = [
  { topic_key: "study_stress" },
  { topic_key: "money_stress" },
  { topic_key: "relationship_conflict" },
  { topic_key: "sleep_problems" },
];

export const mockContent = [
  {
    actionBlock: {
      TopicKey: "study_stress",
      Block: {
        EmpathyOpeners: [
          "Exams can be overwhelming, you're not alone.",
          "Feeling stressed about studies is normal; it shows you care.",
        ],
        MicroSteps: [
          "Make a simple 3-item to-do list.",
          "Take a 5-minute stretch break.",
          "Review one topic at a time.",
        ],
        Scripts: [
          "I can handle one subject at a time.",
          "I don’t need to be perfect, I just need to try.",
        ],
        ToolLinks: [{ Title: "Pomodoro Timer", URL: "https://pomofocus.io" }],
        IfWorse: [
          "If panic builds, try the 5-4-3-2-1 grounding exercise.",
          "If stress keeps rising, talk to someone you trust.",
        ],
        Disclaimer: "General wellbeing info, not medical advice.",
      },
      Language: "en",
    },
  },
  {
    actionBlock: {
      TopicKey: "money_stress",
      Block: {
        EmpathyOpeners: [
          "Money worries can feel heavy, but small steps help.",
          "You're not alone—many people face financial stress.",
        ],
        MicroSteps: [
          "Write down your top 3 monthly expenses.",
          "Identify one expense you can reduce this week.",
          "Set a 30-minute block to review your budget.",
        ],
        Scripts: [
          "I’ll start by writing down what I spend most on.",
          "It’s okay to take small steps with money.",
        ],
        ToolLinks: [
          { Title: "Budget Planner", URL: "https://everydollar.com" },
        ],
        IfWorse: [
          "If money stress feels overwhelming, consider talking to a financial advisor.",
          "Reach out to family or a trusted friend for support.",
        ],
        Disclaimer:
          "This is not financial advice, just general wellbeing tips.",
      },
      Language: "en",
    },
  },
  {
    actionBlock: {
      TopicKey: "sleep_problems",
      Block: {
        EmpathyOpeners: [
          "Struggling with sleep can be exhausting.",
          "It's tough when your mind won’t switch off.",
        ],
        MicroSteps: [
          "Try a simple breathing exercise before bed.",
          "Avoid screens for 30 minutes before sleeping.",
          "Write down tomorrow’s worries to clear your mind.",
        ],
        Scripts: [
          "I can relax my body one part at a time.",
          "Even if I don’t sleep right away, resting is still helpful.",
        ],
        ToolLinks: [{ Title: "Sleep Sounds", URL: "https://noisli.com" }],
        IfWorse: [
          "If sleeplessness continues, consult a healthcare provider.",
          "Persistent insomnia can benefit from professional support.",
        ],
        Disclaimer: "General wellbeing info, not medical advice.",
      },
      Language: "en",
    },
  },
];

export const mockCompose = [
  {
    card: `
  **Study Stress Relief**
  - Break tasks into smaller chunks.
  - Take a 5-minute break after each 30–45 mins of study.
  - Review one subject at a time.
  
  *If stress builds, open the grounding exercise.*
  ---
  _General wellbeing info, not medical advice._
  `,
    message: "action card generated successfully",
  },
  {
    card: `
  **Money Stress Basics**
  - Write down your top 3 expenses.
  - Identify one expense to cut this week.
  - Set a 30-minute time to review your budget.
  
  *If money stress feels overwhelming, talk to someone you trust.*
  ---
  _This is general wellbeing support, not financial advice._
  `,
    message: "action card generated successfully",
  },
  {
    card: `
  **Better Sleep Tonight**
  - Avoid screens 30 mins before bed.
  - Try a breathing exercise (4-4-4-4).
  - Write down tomorrow’s to-dos to clear your mind.
  
  *If insomnia persists, consider reaching out to a healthcare provider.*
  ---
  _General wellbeing info, not medical advice._
  `,
    message: "action card generated successfully",
  },
];
