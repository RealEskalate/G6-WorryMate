export const locales = ['en', 'am'] as const;
export type Locale = (typeof locales)[number];

export const defaultLocale: Locale = 'en';
