'use client';

import { useState, useEffect } from 'react';
import { useRouter, usePathname } from 'next/navigation';
import { GlobeAltIcon } from '@heroicons/react/24/outline';

export default function FloatingLanguageSwitcher() {
  const router = useRouter();
  const pathname = usePathname();
  const [isOpen, setIsOpen] = useState(false);
  const [currentLocale, setCurrentLocale] = useState('en');

  useEffect(() => {
    // Get current locale from URL
    const locale = pathname.split('/')[1];
    if (locale === 'fa' || locale === 'en') {
      setCurrentLocale(locale);
    }
  }, [pathname]);

  const switchLanguage = (locale: string) => {
    const newPath = pathname.replace(/^\/[a-z]{2}/, `/${locale}`);
    router.push(newPath);
    setIsOpen(false);
  };

  return (
    <div className="fixed bottom-8 right-8 z-50">
      <div className="relative">
        <button
          onClick={() => setIsOpen(!isOpen)}
          className="flex items-center justify-center w-12 h-12 rounded-full bg-primary text-white shadow-lg hover:bg-primary-dark transition-colors duration-200"
        >
          <GlobeAltIcon className="w-6 h-6" />
        </button>

        {isOpen && (
          <div className="absolute bottom-16 right-0 bg-white rounded-lg shadow-lg py-2 w-32">
            <button
              onClick={() => switchLanguage('en')}
              className={`w-full px-4 py-2 text-right hover:bg-gray-100 transition-colors duration-200 ${
                currentLocale === 'en' ? 'text-primary font-medium' : 'text-gray-700'
              }`}
            >
              English
            </button>
            <button
              onClick={() => switchLanguage('fa')}
              className={`w-full px-4 py-2 text-right hover:bg-gray-100 transition-colors duration-200 ${
                currentLocale === 'fa' ? 'text-primary font-medium' : 'text-gray-700'
              }`}
            >
              فارسی
            </button>
          </div>
        )}
      </div>
    </div>
  );
} 