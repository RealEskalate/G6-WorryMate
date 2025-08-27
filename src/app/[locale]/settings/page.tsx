import {getTranslations} from 'next-intl/server';
import LanguageSelect from './parts/LanguageSelect';

export default async function SettingsPage() {
  const t = await getTranslations('Settings');

  return (
    <main className="max-w-xl mx-auto p-6 space-y-4">
      <h1 className="text-2xl font-semibold">{t('title')}</h1>

      <section className="space-y-2">
        <label className="block text-sm">{t('language')}</label>
        <LanguageSelect />
      </section>
    </main>
  );
}
