
import { NextRequest, NextResponse } from 'next/server';

export async function POST(request: NextRequest) {
  const targetUrl = 'https://g6-worrymate-zt0r.onrender.com/chat/compose';
  
  try {
    const body = await request.json();
    console.log('Proxying request to:', targetUrl);
    console.log('Request body:', body);
    
    // Make the request to the external API
    const response = await fetch(targetUrl, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(body),
    });
    
    console.log('Backend response status:', response.status);
    
    if (!response.ok) {
      // Try to get the error message from the backend
      let errorText = '';
      try {
        errorText = await response.text();
      } catch (e) {
        errorText = 'Unable to read error response';
      }
      
      console.error('Backend error:', errorText);
      throw new Error(`Backend error: ${response.status} - ${errorText}`);
    }
    
    // Get the response data
    const data = await response.json();
    console.log('Backend response data:', data);
    
    // Return the data as-is to the frontend
    return NextResponse.json(data);
    
  } catch (error) {
    console.error('API route error:', error);
    
    // Return a proper error response with details
    return NextResponse.json(
      { 
        error: 'Failed to fetch action card',
        details: error.message,
        stack: process.env.NODE_ENV === 'development' ? error.stack : undefined
      },
      { status: 500 }
    );
  }
}

// Handle OPTIONS requests for CORS preflight
export async function OPTIONS() {
  return new NextResponse(null, {
    status: 200,
    headers: {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'POST, OPTIONS',
      'Access-Control-Allow-Headers': 'Content-Type',
    },
  });
}