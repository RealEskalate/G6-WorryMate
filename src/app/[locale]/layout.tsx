import {NextIntlClientProvider, hasLocale} from 'next-intl';
import {notFound} from 'next/navigation';
import {routing} from '@/i18n/routing';
import { Metadata } from 'next';
import Header from '@/components/Header';
import '@/app/globals.css';

type Props = {
  children: React.ReactNode;
  params: Promise<{locale: string}>;
};
export const metadata: Metadata = {
  title: "WorryMate",
  description: "Your AI companion for mental wellness",
};

export default async function RootLayout({
  children, params
}: Readonly<{
  children: React.ReactNode;
  params: Promise<{locale: string}>;
}>) {
  const {locale} = await params;
  if (!hasLocale(routing.locales, locale)) {
    notFound();
  }
  return (
    <html>
      <body>
        <NextIntlClientProvider>
          <Header />
          {children}
        </NextIntlClientProvider>
      </body>
    </html>
  );
}
