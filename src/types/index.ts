export type ActionStep =
  | string
  | { step: string }
  | { text: string }
  | { description: string }

export interface ActionCardData {
  title: string;
  description: string;
  steps: ActionStep[];
  miniTools: Array<{ title: string; url: string }>;
  ifWorse: string;
  disclaimer: string;
  // Optional fields used in UI
  empathyOpeners?: string[];
  scripts?: string[];
  uiTools?: unknown[];
  __crisis?: boolean;
}

// export interface MiniTool {
//   id: string;
//   name: string;
//   icon: string;
// }

export interface CrisisResourceContact {
  phone?: string;
  website?: string;
  email?: string;
  availability?: string;
}

export interface CrisisResource {
  name: string;
  type?: string;
  contact?: CrisisResourceContact;
}

export interface CrisisSafetyStep {
  step: string | number;
  instruction: string;
}

export interface CrisisCardData {
  region?: string;
  safety_plan?: CrisisSafetyStep[];
  resources?: CrisisResource[];
  disclaimer?: string;
}
