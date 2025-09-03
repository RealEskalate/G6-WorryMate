import React from 'react'

async function getter(){
    const res=await fetch("https://api.quotable.io/random?tags=motivational&maxLength=100")
}
function GetQuote() {
  return (
    <div>
      
    </div>
  )
}

export default GetQuote
