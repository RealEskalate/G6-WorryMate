import React from "react";
import { useId } from "react";

export function FeaturesSectionDemo() {
    return (
        <div className="py-20 lg:py-40">
            <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-10 md:gap-2 max-w-7xl mx-auto">
                {grid.map((feature) => (
                    <div
                        key={feature.title}
                        className="relative bg-gradient-to-b dark:from-neutral-900 from-neutral-100 dark:to-neutral-950 to-white p-6 rounded-3xl overflow-hidden"
                    >
                        <Grid size={20} />
                        <p className="text-base font-bold text-neutral-800 dark:text-white relative z-20">
                            {feature.title}
                        </p>
                        <p className="text-neutral-600 dark:text-neutral-400 mt-4 text-base font-normal relative z-20">
                            {feature.description}
                        </p>
                    </div>
                ))}
            </div>
        </div>
    );
}

const grid = [
    {
        title: "Privacy & Safety First",
        description:
            "Your chats stay private — nothing is stored on our servers. Local-only saves are always in your control.",
    },
    {
        title: "Bilingual Support",
        description:
            "Chat freely in Amharic or English. WorryMate listens and responds in the language that feels most natural to you.",
    },
    {
        title: "AI Buddy, Not a Therapist",
        description:
            "WorryMate is a supportive friend that helps you reflect, breathe, and take small steps forward — never clinical or diagnostic.",
    },
    {
        title: "Crisis Response",
        description:
            "If you mention self-harm, violence, or emergencies, WorryMate immediately shows crisis resources and safety steps.",
    },
    {
        title: "Offline Toolkit",
        description:
            "Access breathing timers, grounding exercises, journaling prompts, and a win tracker anytime — even without internet.",
    },
    {
        title: "Action Cards",
        description:
            "Turn worries into small, doable steps with clear tips, micro-exercises, and resource links tailored to your situation.",
    },
    {
        title: "Simple & Calming Design",
        description:
            "A warm, friendly space that feels safe. No clutter, no judgment — just support in a calming interface.",
    },
    {
        title: "Lightweight & Accessible",
        description:
            "Optimized for low-bandwidth connections and everyday devices, so support is always within reach.",
    },
];

export const Grid = ({
    pattern,
    size,
}: {
    pattern?: [number, number][];
    size?: number;
}) => {
    const p: [number, number][] = pattern ?? [
        [Math.floor(Math.random() * 4) + 7, Math.floor(Math.random() * 6) + 1],
        [Math.floor(Math.random() * 4) + 7, Math.floor(Math.random() * 6) + 1],
        [Math.floor(Math.random() * 4) + 7, Math.floor(Math.random() * 6) + 1],
        [Math.floor(Math.random() * 4) + 7, Math.floor(Math.random() * 6) + 1],
        [Math.floor(Math.random() * 4) + 7, Math.floor(Math.random() * 6) + 1],
    ];
    return (
        <div className="pointer-events-none absolute left-1/2 top-0  -ml-20 -mt-2 h-full w-full [mask-image:linear-gradient(white,transparent)]">
            <div className="absolute inset-0 bg-gradient-to-r  [mask-image:radial-gradient(farthest-side_at_top,white,transparent)] dark:from-zinc-900/30 from-zinc-100/30 to-zinc-300/30 dark:to-zinc-900/30 opacity-100">
                <GridPattern
                    width={size ?? 20}
                    height={size ?? 20}
                    x={-12}
                    y={4}
                    squares={p}
                    className="absolute inset-0 h-full w-full  mix-blend-overlay dark:fill-white/10 dark:stroke-white/10 stroke-black/10 fill-black/10"
                />
            </div>
        </div>
    );
};

type GridPatternProps = {
    width: number;
    height: number;
    x: number;
    y: number;
    squares?: [number, number][];
} & React.SVGProps<SVGSVGElement>;

export function GridPattern({ width, height, x, y, squares, ...props }: GridPatternProps) {
    const patternId = useId();

    return (
        <svg aria-hidden="true" {...props}>
            <defs>
                <pattern
                    id={patternId}
                    width={width}
                    height={height}
                    patternUnits="userSpaceOnUse"
                    x={x}
                    y={y}
                >
                    <path d={`M.5 ${height}V.5H${width}`} fill="none" />
                </pattern>
            </defs>
            <rect
                width="100%"
                height="100%"
                strokeWidth={0}
                fill={`url(#${patternId})`}
            />
            {squares && (
                <svg x={x} y={y} className="overflow-visible">
                    {squares.map(([x, y]: [number, number]) => (
                        <rect
                            strokeWidth="0"
                            key={`${x}-${y}`}
                            width={width + 1}
                            height={height + 1}
                            x={x * width}
                            y={y * height}
                        />
                    ))}
                </svg>
            )}
        </svg>
    );
}
