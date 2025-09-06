import React from 'react'
import { AlertTriangle, Clock, Crown } from 'lucide-react'

interface OtherCardProps {
    type?: 'rate_limit' | 'error' | 'info'
    title?: string
    message?: string
    showPremium?: boolean
}

const OtherCard: React.FC<OtherCardProps> = ({
    type = 'rate_limit',
    title = "Rate Limit Reached",
    message = "You've reached your usage limit for today. Please try again later or upgrade to premium for unlimited access.",
    showPremium = true
}) => {
    return (
        <div className="w-full max-w-[85%] border-2 border-yellow-300 dark:border-green-500 rounded-lg p-4 bg-gradient-to-br from-yellow-50 to-amber-50 dark:bg-none dark:bg-transparent shadow-lg dark:shadow-[0_0_0_1px_rgba(255,255,255,0.08),0_4px_14px_-2px_rgba(0,0,0,0.55)] transition-colors">
            <div className="flex items-start gap-3">
                <div className="flex-shrink-0">
                    <AlertTriangle className="w-6 h-6 text-yellow-600 dark:text-white" />
                </div>
                <div className="flex-1">
                    <h2 className="text-lg font-bold text-yellow-800 dark:text-white mb-2 flex items-center gap-2">
                        {title}
                        {type === 'rate_limit' && <Clock className="w-4 h-4" />}
                    </h2>

                    <p className="text-sm text-yellow-700 dark:text-white mb-4 leading-relaxed">
                        {message}
                    </p>

                    {showPremium && (
                        <div className="bg-white/60 dark:bg-transparent rounded-lg p-3 border border-yellow-200 dark:border-green-500/50 backdrop-blur supports-[backdrop-filter]:bg-white/50 dark:supports-[backdrop-filter]:bg-transparent transition-colors">
                            <div className="flex items-center gap-2 mb-2">
                                <Crown className="w-4 h-4 text-amber-600 dark:text-white" />
                                <span className="font-semibold text-amber-800 dark:text-white text-sm">Upgrade to Premium</span>
                            </div>
                            <p className="text-xs text-amber-700 dark:text-white/90 mb-3">
                                Get unlimited access to all features and priority support
                            </p>
                            <button className="bg-gradient-to-r from-amber-500 to-yellow-500 hover:from-amber-600 hover:to-yellow-600 dark:from-green-600 dark:to-emerald-500 dark:hover:from-green-500 dark:hover:to-emerald-400 text-white font-semibold py-2 px-4 rounded-md text-sm transition-all duration-200 shadow-md hover:shadow-lg focus:outline-none focus:ring-2 focus:ring-amber-400/60 dark:focus:ring-green-500/50">
                                Upgrade Now
                            </button>
                        </div>
                    )}

                    <div className="mt-3 pt-3 border-t border-yellow-200 dark:border-green-500/50">
                        <p className="text-xs text-yellow-600 dark:text-white/80 italic">
                            💡 Tip: Try again in a few minutes or contact support if you need immediate assistance
                        </p>
                    </div>
                </div>
            </div>
        </div>
    )
}

export default OtherCard