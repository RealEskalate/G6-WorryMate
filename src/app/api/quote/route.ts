import { NextResponse } from 'next/server';

export async function GET() {
  try {
    console.log('Fetching quotes from Type.fit...');
    const res = await fetch('https://type.fit/api/quotes', {
      cache: 'no-store',
      headers: {
        'Accept': 'application/json',
      },
    });
    console.log('Type.fit response status:', res.status);
    if (!res.ok) {
      throw new Error(`Type.fit API returned status: ${res.status} ${res.statusText}`);
    }
    const data = await res.json();
    console.log('Type.fit response data length:', data.length);
    return NextResponse.json(data);
  } catch (error: any) {
    console.error('Error in /api/quote:', error.message, error.stack);
    return NextResponse.json(
      { error: 'Failed to fetch quotes', details: error.message },
      { status: 500 }
    );
  }
}