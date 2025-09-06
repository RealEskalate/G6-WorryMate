import { routing } from "@/i18n/routing";
export const dynamic = "force-dynamic";

export async function POST(request: Request) {
  try {
    const url = new URL(request.url);
    const bodyText = await request.text();
    const body = bodyText ? bodyText : JSON.stringify({});
    console.log("request body", body);

    // Determine locale
    type Locale = (typeof routing)["locales"][number];
    const toLocale = (val?: string | null): Locale | undefined => {
      if (!val) return undefined;
      const v = val.toLowerCase();
      return (routing.locales as readonly string[]).includes(v)
        ? (v as Locale)
        : undefined;
    };

    const qpLocale = toLocale(url.searchParams.get("locale"));
    const headerLocale = toLocale(request.headers.get("x-locale"));
    let refererLocale: Locale | undefined;
    const referer = request.headers.get("referer") ?? "";
    if (referer) {
      try {
        const refUrl = new URL(referer);
        const firstSeg = refUrl.pathname.split("/").filter(Boolean)[0];
        refererLocale = toLocale(firstSeg ?? undefined);
      } catch {}
    }

    const locale: Locale =
      qpLocale || headerLocale || refererLocale || routing.defaultLocale;

    const upstream = await fetch(
      `https://g6-worrymate-8osd.onrender.com/chat/normal?region=ET&lang=${locale}`,
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
    console.log("WorryMate response:", upstreamBody);

    if (!upstream.ok) {
      return new Response(
        JSON.stringify({
          ok: false,
          status: upstream.status,
          message: "Upstream normal-chat error",
          body: upstreamBody,
        }),
        {
          status: upstream.status,
          headers: { "content-type": "application/json" },
        }
      );
    }

    // Extract AI response
    const reply =
      typeof upstreamBody === "object" && upstreamBody !== null
        ? (upstreamBody as any).ai_response ?? "Sorry, I couldn't respond."
        : String(upstreamBody);

    return new Response(JSON.stringify({ reply }), {
      status: 200,
      headers: { "content-type": "application/json" },
    });
  } catch (e: unknown) {
    return new Response(
      JSON.stringify({
        error: "Failed to fetch normal chat",
        detail:
          typeof e === "object" && e !== null && "message" in e
            ? String((e as { message?: unknown }).message)
            : String(e),
      }),
      { status: 500, headers: { "content-type": "application/json" } }
    );
  }
}
