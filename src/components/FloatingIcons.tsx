import React from 'react';

const icons = [
    { src: '/file.svg', alt: 'File', top: '10%', left: '5%' },
    { src: '/family.png', alt: 'Family', top: '30%', left: '10%' },
    { src: '/financial-statement.png', alt: 'Financial Statement', top: '70%', left: '5%' },
    { src: '/exam-time.png', alt: 'Exam Time', top: '15%', right: '5%' },
    { src: '/better-health.png', alt: 'Better Health', top: '45%', right: '10%' },
    { src: '/window.svg', alt: 'Window', top: '75%', right: '5%' },
];

const FloatingIcons = () => {
    return (
        <>
            {icons.map((item, index) => (
                <div
                    key={index}
                    className="absolute z-0 opacity-40 animate-float"
                    style={{
                        top: item.top,
                        left: item.left,
                        right: item.right,
                        animationDelay: `${index * 0.5}s`,
                    }}
                >
                    <div className="p-1 shadow-lg">
                        <img src={item.src} alt={item.alt} className="w-5 h-5 object-contain" />
                    </div>
                </div>
            ))}
        </>
    );
};

export default FloatingIcons;