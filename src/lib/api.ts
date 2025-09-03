
export async function fetchActionCard(cardKey = "study_stress") {
  try {
    console.log('Fetching action card for:', cardKey);
    const payload = { cardKey: cardKey };
    console.log('Request payload:', JSON.stringify(payload));
    const response = await fetch(`/api`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(payload),
    });

    console.log('API response status:', response.status);
    const apiResponse = await response.json();
    console.log('Raw API response:', apiResponse);

    if (!response.ok) {
      // Try to get error details from response
      const errorData = apiResponse || {};
      throw new Error(`Failed to fetch action card: ${response.status} - ${errorData.error || 'Unknown error'}`);
    }

    if (!apiResponse.card) {
      throw new Error('No card data in response');
    }

    // Clean the response by removing markdown code blocks
    const cleanedResponse = apiResponse.card
      .replace(/```json\n?/g, '')
      .replace(/```\n?/g, '')
      .trim();
    console.log('Cleaned card string:', cleanedResponse);
    let cardData;
    try {
      cardData = JSON.parse(cleanedResponse);
    } catch (e) {
      console.error('Failed to parse card JSON:', cleanedResponse);
      return null;
    }
    console.log('Parsed cardData:', cardData);
    const usefulData = cardData[cardKey];
    if (!usefulData) {
      // Log the cardData for debugging
      console.warn("Card key not found, cardData:", cardData);
      // Optionally, show an error or fallback to a default card
      return null;
    }
    return usefulData;
  } catch (error) {
    console.error("Failed to fetch action card:", error);
    return null;
  }
}