export const dynamic = "force-dynamic";

export async function POST(request: Request) {
  try {
    console.log("url hit");
    // const url = new URL(request.url);
    // const search = url.search;

    const body = await request.text();
    console.log(body);

    const upstream = await fetch(
      "https://g6-worrymate-zt0r.onrender.com/chat/risk_check",
      {
        method: "POST",
        headers: {
          "content-type": "application/json",
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
          message: "Upstream risk-check error",
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
  } catch (e: unknown) {
    return new Response(
      JSON.stringify({
        error: "Failed to fetch risk-check",
        detail:
          typeof e === "object" && e !== null && "message" in e
            ? String((e as { message?: unknown }).message)
            : String(e),
      }),
      { status: 500, headers: { "content-type": "application/json" } }
    );
  }
}
