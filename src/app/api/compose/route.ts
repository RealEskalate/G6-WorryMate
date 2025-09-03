export const dynamic = "force-dynamic";

export async function POST(request: Request) {
  try {
    const url = new URL(request.url);
    const upstreamUrl = "https://g6-worrymate-8osd.onrender.com/chat/compose";
    const body = await request.text();

    const upstream = await fetch(upstreamUrl, {
      method: "POST",
      headers: {
        "content-type": "application/json",
        accept: "application/json",
      },
      cache: "no-store",
      body: body,
    });
    console.log("compose body", body);

    let upstreamBody;
    try {
      upstreamBody = await upstream.json();
      console.log("upstreamBody:", upstreamBody);
    } catch {
      upstreamBody = {};
    }

    // If upstream gave you a markdown-wrapped card string
    if (typeof upstreamBody.card === "string") {
  const stripped = upstreamBody.card
    .replace(/^```json\n?/i, "")
    .replace(/\n?```\s*$/i, "")
    .trim();

  try {
    const parsed = JSON.parse(stripped);

    // unwrap empty key if it exists
    const fixed = parsed[""] ? parsed[""] : parsed;

    upstreamBody = { ...upstreamBody, card: fixed };
  } catch (e) {
    console.error("Failed to parse card string:", e);
  }
}

    }
    console.log("upstreamBody:", upstreamBody);
    return new Response(JSON.stringify(upstreamBody), {
      status: 200,
      headers: { "content-type": "application/json" },
    });
  } catch (e) {
    console.error("err:", e);
  }
}
