import React from 'react'
import JournalEditor from '../_components/JournalEditor'
import { PageHeader } from '@/components/PageHeader'

function page() {
  return (
    <div className='bg-[#F7F9FB] dark:bg-gray-900 min-h-screen overflow-y-auto'>
      <PageHeader title="Journal" />
      <JournalEditor />
    </div>
  )
}

export default page
