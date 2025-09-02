
export async function fetchActionCard(cardKey = "study_stress") {
  try {
    console.log('Fetching action card for:', cardKey);
    
    const response = await fetch(`/api`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        cardKey: cardKey,
      }),
    });

    console.log('API response status:', response.status);
    
    if (!response.ok) {
      // Try to get error details from response
      const errorData = await response.json().catch(() => ({}));
      throw new Error(`Failed to fetch action card: ${response.status} - ${errorData.error || 'Unknown error'}`);
    }

    const apiResponse = await response.json();

    
    if (!apiResponse.card) {
      throw new Error('No card data in response');
    }
    
    // Clean the response by removing markdown code blocks
    const cleanedResponse = apiResponse.card
      .replace(/```json\n?/g, '')
      .replace(/```\n?/g, '')
      .trim();

    const cardData = JSON.parse(cleanedResponse);
    const usefulData = cardData["Relaxation Techniques"];
    console.log(usefulData.description)
    return usefulData;
  } catch (error) {
    console.error("Failed to fetch action card:", error);
    return null;
  }
}