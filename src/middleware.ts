import createMiddleware from 'next-intl/middleware';
import {locales, defaultLocale} from './i18n/config';

export default createMiddleware({
  locales,
  defaultLocale,
  localeDetection: true
});

export const config = {
  // Skip _next, files, and api
  matcher: ['/((?!_next|.*\\..*|api).*)']
};
