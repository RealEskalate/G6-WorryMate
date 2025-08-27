'use client';

const MiniTool = ({ tool, onStart }) => {
  const getToolConfig = (toolKey) => {
    const tools = {
      breathing_exercise: { name: "Start Breathing", icon: "🧘" },
      grounding_54321: { name: "Try Grounding", icon: "🌳" }
    };
    return tools[toolKey] || { name: "Start", icon: "✨" };
  };

  const { name, icon } = getToolConfig(tool);

  return (
    <button
      onClick={() => onStart(tool)}
      className="flex items-center gap-2 px-4 py-2 bg-blue-100 text-blue-800 rounded-lg text-sm font-medium hover:bg-blue-200 transition-colors"
    >
      <span>{icon}</span>
      <span>{name}</span>
    </button>
  );
};

export default MiniTool;