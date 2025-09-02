export interface ActionCardData {
  title: string
  description: string
  steps: string[]
  miniTools: {
    title: string
    url: string
  }[]
  ifWorse: string
  disclaimer: string
}

export interface ApiResponse {
  card: string
  message: string
}


