export const dynamic = "force-dynamic";

export async function GET(request: Request) {
  try {
    console.log("action block url hit");
    const url = new URL(request.url);
    const topic = url.searchParams.get("topic") || "";
    if (!topic) {
      return new Response(
        JSON.stringify({ ok: false, message: "Missing topic" }),
        { status: 400, headers: { "content-type": "application/json" } }
      );
    }

    const upstreamUrl = `https://g6-worrymate-8osd.onrender.com/chat/action_block/${encodeURIComponent(
      topic
    )}/en`;
    const upstream = await fetch(upstreamUrl, {
      method: "GET",
      headers: { accept: "application/json" },
      cache: "no-store",
    });

    const contentType = upstream.headers.get("content-type") || "";
    const isJson = contentType.includes("application/json");
    const body = isJson ? await upstream.json() : await upstream.text();

    if (!upstream.ok) {
      return new Response(
        JSON.stringify({
          ok: false,
          status: upstream.status,
          message: "Upstream action-block error",
          body,
        }),
        {
          status: upstream.status,
          headers: { "content-type": "application/json" },
        }
      );
    }
    console.log("actionblock:", body);

    const payload = isJson ? body : { actionBlock: String(body ?? "") };
    return new Response(JSON.stringify(payload), {
      status: 200,
      headers: { "content-type": "application/json" },
    });
  } catch (e: unknown) {
    return new Response(
      JSON.stringify({
        error: "Failed to fetch action-block",
        detail:
          typeof e === "object" && e !== null && "message" in e
            ? String((e as { message?: unknown }).message)
            : String(e),
      }),
      { status: 500, headers: { "content-type": "application/json" } }
    );
  }
}
