import { NextResponse } from 'next/server';

export async function GET() {
    try {
        const response = await fetch('https://g6-worrymate-zt0r.onrender.com/chat/risk_check');
        if (!response.ok) {
            return NextResponse.json({ error: 'Failed to fetch risk check data' }, { status: response.status });
        }
        const data = await response.json();
        return NextResponse.json(data);
    } catch (error) {
        return NextResponse.json({ error: 'Internal server error' }, { status: 500 });
    }
}