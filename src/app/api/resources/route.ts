export const dynamic = "force-dynamic";

export async function GET() {
  try {
    const upstream = await fetch(
      "https://g6-worrymate-zt0r.onrender.com/chat/resources",
      {
        method: "GET",
        headers: { accept: "application/json" },
        cache: "no-store",
      }
    );

    const contentType = upstream.headers.get("content-type") || "";
    const isJson = contentType.includes("application/json");
    const body = isJson ? await upstream.json() : await upstream.text();

    if (!upstream.ok) {
      return new Response(
        JSON.stringify({ ok: false, status: upstream.status, body }),
        {
          status: upstream.status,
          headers: { "content-type": "application/json" },
        }
      );
    }

    const payload = isJson ? body : { raw: String(body ?? "") };
    return new Response(JSON.stringify(payload), {
      status: 200,
      headers: { "content-type": "application/json" },
    });
  } catch (e: any) {
    return new Response(
      JSON.stringify({
        error: "Failed to fetch resources",
        detail: String(e?.message || e),
      }),
      { status: 500, headers: { "content-type": "application/json" } }
    );
  }
}
