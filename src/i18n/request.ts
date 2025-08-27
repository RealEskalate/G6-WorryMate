import {getRequestConfig} from 'next-intl/server';
import {locales} from './config';

export default getRequestConfig(async ({locale}) => {
  // Fallback if someone hits an unsupported locale
  const safeLocale = locales.includes(locale as any) ? locale : 'en';

  return {
    messages: (await import(`../messages/${safeLocale}.json`)).default
  };
});
