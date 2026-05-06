import React from 'react'
import { Heart, Users, BookOpen, Clock, Home, Brain, Zap, Coffee, DollarSign, GraduationCap } from 'lucide-react'

const GeneralSupportCard: React.FC = () => {
    const focusAreas = [
        { name: 'Self-confidence', icon: Heart, color: 'text-pink-600' },
        { name: 'New city anxiety', icon: Home, color: 'text-blue-600' },
        { name: 'Exam panic', icon: BookOpen, color: 'text-red-600' },
        { name: 'Motivation', icon: Zap, color: 'text-yellow-600' },
        { name: 'Time management', icon: Clock, color: 'text-green-600' },
        { name: 'Family conflicts', icon: Users, color: 'text-purple-600' },
        { name: 'Procrastination', icon: Coffee, color: 'text-orange-600' },
        { name: 'Loneliness', icon: Heart, color: 'text-rose-600' },
        { name: 'Sleep', icon: Brain, color: 'text-indigo-600' },
        { name: 'Workload', icon: BookOpen, color: 'text-teal-600' },
        { name: 'Money stress', icon: DollarSign, color: 'text-emerald-600' },
        { name: 'Study stress', icon: GraduationCap, color: 'text-cyan-600' }
    ]

    return (
        <div className="w-full max-w-[85%] border-2 border-blue-200 rounded-xl p-6 bg-gradient-to-br from-blue-50 to-indigo-50 shadow-lg">
            <div className="text-center mb-6">
                <h2 className="text-2xl font-bold text-blue-800 mb-3 flex items-center justify-center gap-2">
                    <Heart className="w-6 h-6 text-blue-600" />
                    General Support
                </h2>
                <p className="text-blue-700 text-base leading-relaxed">
                    Take a moment to review the areas we focus on. See if your concern connects with any of these; sometimes challenges overlap.
                </p>
            </div>

            <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-3 mb-6">
                {focusAreas.map((area, index) => {
                    const IconComponent = area.icon
                    return (
                        <div
                            key={index}
                            className="flex items-center gap-2 p-2 rounded-lg bg-white/60 border border-blue-100 hover:bg-white/80 transition-colors"
                        >
                            <IconComponent className={`w-4 h-4 ${area.color} flex-shrink-0`} />
                            <span className="text-sm text-blue-800 font-medium">{area.name}</span>
                        </div>
                    )
                })}
            </div>

            <div className="space-y-4">
                <div className="bg-white/60 rounded-lg p-4 border border-blue-100">
                    <h3 className="font-semibold text-blue-800 mb-2 flex items-center gap-2">
                        <Zap className="w-4 h-4 text-blue-600" />
                        Next Steps
                    </h3>
                    <div className="space-y-2 text-sm text-blue-700">
                        <p>• <strong>Identify Connection:</strong> Consider if your current challenge relates to one of the listed areas above.</p>
                        <p>• <strong>Explore Resources:</strong> Once you&apos;ve identified a related area, search for resources or support tailored to that specific concern.</p>
                    </div>
                </div>

                <div className="bg-amber-50 border border-amber-200 rounded-lg p-4">
                    <h3 className="font-semibold text-amber-800 mb-2 flex items-center gap-2">
                        <Heart className="w-4 h-4 text-amber-600" />
                        If Things Get Worse
                    </h3>
                    <p className="text-sm text-amber-700">
                        If your distress persists or worsens, please reach out to a mental health professional or a trusted individual for support.
                    </p>
                </div>

                <div className="text-center pt-2">
                    <p className="text-xs text-blue-600 italic">
                        💡 This is general wellbeing information, not medical or mental health advice.
                    </p>
                </div>
            </div>
        </div>
    )
}

export default GeneralSupportCard
