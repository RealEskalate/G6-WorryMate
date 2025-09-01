export const dynamic = "force-dynamic";

export async function GET(request: Request) {
  try {
    const url = new URL(request.url);
    const search = url.search;
    const upstreamUrl = `https://g6-worrymate-zt0r.onrender.com/chat/compose${
      search || ""
    }`;

    const upstream = await fetch(upstreamUrl, {
      method: "GET",
      // Forward minimal headers; customize if needed
      headers: { accept: "application/json" },
      // Ensure we don't cache in edge/CDN inadvertently
      cache: "no-store",
    });

    const contentType = upstream.headers.get("content-type") || "";
    const isJson = contentType.includes("application/json");
    const body = isJson ? await upstream.json() : await upstream.text();

    if (!upstream.ok) {
      // Fallback: some backends might require POST; we try it once
      let fallbackBody: unknown = body;
      try {
        const prompt = url.searchParams.get("prompt");
        const upstreamPost = await fetch(
          "https://g6-worrymate-zt0r.onrender.com/chat/compose",
          {
            method: "POST",
            headers: {
              "content-type": "application/json",
              accept: "application/json",
            },
            cache: "no-store",
            body: JSON.stringify(prompt ? { prompt } : {}),
          }
        );
        const postContentType = upstreamPost.headers.get("content-type") || "";
        const postIsJson = postContentType.includes("application/json");
        fallbackBody = postIsJson
          ? await upstreamPost.json()
          : await upstreamPost.text();
        if (upstreamPost.ok) {
          const payload = postIsJson
            ? fallbackBody
            : { card: String(fallbackBody ?? ""), message: "ok" };
          return new Response(JSON.stringify(payload), {
            status: 200,
            headers: { "content-type": "application/json" },
          });
        }
      } catch {}

      return new Response(
        JSON.stringify({
          ok: false,
          status: upstream.status,
          message: "Upstream compose returned an error",
          body: fallbackBody,
        }),
        {
          status: upstream.status,
          headers: { "content-type": "application/json" },
        }
      );
    }

    // If JSON, pass through; if text, wrap as JSON
    const payload = isJson ? body : { card: String(body ?? ""), message: "ok" };
    return new Response(JSON.stringify(payload), {
      status: 200,
      headers: { "content-type": "application/json" },
    });
  } catch (e: unknown) {
    return new Response(
      JSON.stringify({
        error: "Failed to fetch compose",
        detail:
          typeof e === "object" && e !== null && "message" in e
            ? String((e as { message?: unknown }).message)
            : String(e),
      }),
      {
        status: 500,
        headers: { "content-type": "application/json" },
      }
    );
  }
}

export async function POST(request: Request) {
  try {
    const url = new URL(request.url);
    const search = url.search;
    const upstreamUrl = `https://g6-worrymate-zt0r.onrender.com/chat/compose${
      search || ""
    }`;
    const body = await request.text();

    const upstream = await fetch(upstreamUrl, {
      method: "POST",
      headers: {
        "content-type": "application/json",
        accept: "application/json",
      },
      cache: "no-store",
      body: body || JSON.stringify({}),
    });

    const contentType = upstream.headers.get("content-type") || "";
    const isJson = contentType.includes("application/json");
    const upstreamBody = isJson ? await upstream.json() : await upstream.text();

    if (!upstream.ok) {
      return new Response(
        JSON.stringify({
          ok: false,
          status: upstream.status,
          message: "Upstream compose error",
          body: upstreamBody,
        }),
        {
          status: upstream.status,
          headers: { "content-type": "application/json" },
        }
      );
    }

    const payload = isJson
      ? upstreamBody
      : { card: String(upstreamBody ?? ""), message: "ok" };
    return new Response(JSON.stringify(payload), {
      status: 200,
      headers: { "content-type": "application/json" },
    });
  } catch (e: unknown) {
    return new Response(
      JSON.stringify({
        error: "Failed to fetch compose (POST)",
        detail:
          typeof e === "object" && e !== null && "message" in e
            ? String((e as { message?: unknown }).message)
            : String(e),
      }),
      { status: 500, headers: { "content-type": "application/json" } }
    );
  }
}
