import React from 'react'
import dashImage from '../../public/chatpage.png'
// import GradientBackground from './GradientBackground'
import Image from 'next/image';
import { BorderBeam } from './magicui/border-beam';
import darkImage from '../../public/darkchat.png'

const DashImage = () => {
    return (
        <div className="mt-6 relative w-11/12 max-w-6xl mx-auto h-[80vh] overflow-hidden rounded-xl">
            {/* <GradientBackground> */}
            <div className="absolute inset-0 flex items-center justify-center z-20">
                {/* Dark mode image */}
                <Image
                    src={darkImage}
                    alt="Dashboard"
                    className="hidden dark:block rounded-lg shadow-2xl max-w-full max-h-full object-contain opacity-90"
                />
                {/* Light mode image */}
                <Image
                    src={dashImage}
                    alt="Dashboard"
                    className="block dark:hidden rounded-lg shadow-2xl max-w-full max-h-full object-contain opacity-90"
                />
            </div>
            <BorderBeam
                duration={6}
                size={400}
                className="from-transparent via-red-500 to-transparent"
            />
            <BorderBeam
                duration={6}
                delay={3}
                size={400}
                borderWidth={2}
                className="from-transparent via-blue-500 to-transparent"
            />
            {/* </GradientBackground> */}
        </div >
    )
}

export default DashImage