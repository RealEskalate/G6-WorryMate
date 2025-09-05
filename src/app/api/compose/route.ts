// export const dynamic = "force-dynamic";

// export async function POST(request: Request) {
//   try {
//     const url = new URL(request.url);
//     const upstreamUrl = "https://g6-worrymate-8osd.onrender.com/chat/compose";
//     const body = await request.text();

//     const upstream = await fetch(upstreamUrl, {
//       method: "POST",
//       headers: {
//         "content-type": "application/json",
//         accept: "application/json",
//       },
//       cache: "no-store",
//       body: body,
//     });
//     console.log("compose body", body);

//     let upstreamBody;
//     try {
//       upstreamBody = await upstream.json();
//       console.log("upstreamBody:", upstreamBody);
//     } catch {
//       upstreamBody = {};
//     }

//     // If upstream gave you a markdown-wrapped card string
//     if (typeof upstreamBody.card === "string") {
//       const stripped = upstreamBody.card
//         .replace(/^```json\n?/i, "")
//         .replace(/\n?```\s*$/i, "")
//         .trim();

//       try {
//         const parsed = JSON.parse(stripped);
//         const fixed = parsed[""] ? parsed[""] : parsed;

//         upstreamBody = { ...upstreamBody, card: fixed };

//         // Handle the case where AI puts everything under a random key like "study_stress"
//         const firstKey = Object.keys(parsed)[0];
//         if (firstKey) {
//           upstreamBody = parsed[firstKey];
//         } else {
//           upstreamBody = parsed;
//         }
//       } catch (e) {
//         console.error("Failed to parse upstream card string:", e);
//       }
//     }
//     console.log("upstreamBody:", upstreamBody);
//     return new Response(JSON.stringify(upstreamBody), {
//       status: 200,
//       headers: { "content-type": "application/json" },
//     });
//   } catch (e) {
//     console.error("err:", e);
//   }
// }

import { NextRequest, NextResponse } from "next/server";

export async function POST(request: NextRequest) {
  const targetUrl = "https://g6-worrymate-8osd.onrender.com/chat/compose";

  try {
    const body = await request.json();
    console.log("Incoming frontend request body:", body);

    // Transform into what backend expects
    const payload = {
      topic_key: body.topic || body.topic_key,
      block: body.action_block || body.block,
      language: body.language || "en", // default to English if not provided
    };

    console.log("Proxying payload to backend:", payload);

    const response = await fetch(targetUrl, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(payload),
    });

    console.log("Backend response status:", response.status);

    const text = await response.text();
    let data: unknown;
    try {
      data = JSON.parse(text);
    } catch {
      data = { raw: text } as { raw: string };
    }

    if (!response.ok) {
      console.error("Backend error:", data);
      return NextResponse.json(
        { error: "Backend error", details: data },
        { status: response.status }
      );
    }

    console.log("Backend response data:", data);

    // ✅ Return clean JSON to the frontend
    return NextResponse.json(data);
  } catch (error) {
    console.error("API route error:", error);
    return NextResponse.json(
      {
        error: "Failed to fetch action card",
        details: error instanceof Error ? error.message : String(error),
      },
      { status: 500 }
    );
  }
}
