export const dynamic = "force-dynamic";

export async function POST(request: Request) {
  try {
    const bodyText = await request.text();
    const body = bodyText ? bodyText : JSON.stringify({});
    console.log("request body", body);

    // Post tags to upstream; adjust endpoint if backend differs
    const upstream = await fetch(
      "https://g6-worrymate-8osd.onrender.com/chat/crisis_card?region=ET&lang=en",
      {
        method: "POST",
        headers: {
          "content-type": "application/json",
          accept: "application/json",
        },
        cache: "no-store",
        body,
      }
    );

    const contentType = upstream.headers.get("content-type") || "";
    const isJson = contentType.includes("application/json");
    const upstreamBody = isJson ? await upstream.json() : await upstream.text();
    console.log(upstreamBody);

    if (!upstream.ok) {
      return new Response(
        JSON.stringify({
          ok: false,
          status: upstream.status,
          message: "Upstream crisis-card error",
          body: upstreamBody,
        }),
        {
          status: upstream.status,
          headers: { "content-type": "application/json" },
        }
      );
    }

    const payload = isJson ? upstreamBody : { raw: String(upstreamBody ?? "") };
    return new Response(JSON.stringify(payload), {
      status: 200,
      headers: { "content-type": "application/json" },
    });
  } catch (e: unknown) {
    return new Response(
      JSON.stringify({
        error: "Failed to fetch crisis-card",
        detail:
          typeof e === "object" && e !== null && "message" in e
            ? String((e as { message?: unknown }).message)
            : String(e),
      }),
      { status: 500, headers: { "content-type": "application/json" } }
    );
  }
}
