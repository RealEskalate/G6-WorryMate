import { notFound } from 'next/navigation';
import { getRequestConfig } from 'next-intl/server';

export default getRequestConfig(async ({ locale }) => {
  // Validate that the incoming `locale` parameter is valid
  if (!['en', 'am'].includes(locale)) notFound();

  return {
    messages: (await import(`./src/messages/${locale}.json`)).default
  };
});
