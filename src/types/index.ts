export interface ActionCardData {
  title: string;
  description: string;
  steps: string[];
  miniTools: Array<{ title: string; url: string }>;
  ifWorse: string;
  disclaimer: string;
}

// export interface MiniTool {
//   id: string;
//   name: string;
//   icon: string;
// }
