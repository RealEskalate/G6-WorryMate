export async function POST(req: Request) {
  const body = await req.json();

  const res = await fetch("https://g6-worrymate-8osd.onrender.com/chat/summarize", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(body),
  });

  const text = await res.text(); 
  return new Response(text, { status: res.status, headers: { "Content-Type": "application/json" } });
}
