'use client';

import { useLanguage } from '@/contexts/LanguageContext';

export default function LanguageSwitcher() {
  const { language, setLanguage } = useLanguage();

  return (
    <button
      onClick={() => setLanguage(language === 'en' ? 'fa' : 'en')}
      className={`fixed ${language === 'fa' ? 'left-4' : 'right-4'} top-4 z-50 px-4 py-2 bg-white rounded-full shadow-md hover:shadow-lg transition-all duration-200 flex items-center space-x-2 font-medium ${
        language === 'fa' ? 'font-arabic' : ''
      }`}
    >
      {language === 'en' ? 'فارسی' : 'English'}
    </button>
  );
} 