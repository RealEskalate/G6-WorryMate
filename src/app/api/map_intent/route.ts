export const dynamic = "force-dynamic";

export async function POST(request: Request) {
  try {
    console.log("map intent Url hit");
    // const url = new URL(request.url);
    // const search = url.search;
    // const upstreamUrl = `${
    //   search || ""
    // }`;
    const body = await request.text();

    const upstream = await fetch(
      "https://g6-worrymate-zt0r.onrender.com/chat/intent_mapping",
      {
        method: "POST",
        headers: {
          "content-type": "application/json",
          accept: "application/json",
        },
        cache: "no-store",
        body: body || JSON.stringify({}),
      }
    );

    // const contentType = upstream.headers.get("content-type") || "";
    // const isJson = contentType.includes("application/json");
    // const upstreamBody = isJson ? await upstream.json() : await upstream.text();
    const upstreamBody = await upstream.json();
    console.log(upstreamBody);
    if (!upstream.ok) {
      return new Response(
        JSON.stringify({
          ok: false,
          status: upstream.status,
          message: "Upstream map-intent error",
          body: upstreamBody,
        }),
        {
          status: upstream.status,
          headers: { "content-type": "application/json" },
        }
      );
    }
    return new Response(JSON.stringify(upstreamBody), {
      status: 200,
      headers: { "content-type": "application/json" },
    });
  } catch (e: any) {
    return new Response(
      JSON.stringify({
        error: "Failed to fetch map-intent",
        detail: String(e?.message || e),
      }),
      { status: 500, headers: { "content-type": "application/json" } }
    );
  }
}



