// import type { NextConfig } from "next";

// const nextConfig: NextConfig = {
//   /* config options here */
// };

// export default nextConfig;
/** 
@type {import('next').NextConfig} */
const nextConfig = {
  async redirects() {
    return [
      {
        source: '/app',   // anyone visiting /app
        destination: '/', // goes to main page
        permanent: true,
      },
    ];
  },
};

module.exports = nextConfig;

