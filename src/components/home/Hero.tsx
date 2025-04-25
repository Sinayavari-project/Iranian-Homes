'use client';

import Image from 'next/image';
import SearchBox from '@/components/common/SearchBox';
import { useLanguage } from '@/contexts/LanguageContext';

export default function Hero() {
  const { t, language } = useLanguage();

  return (
    <div className="relative h-[600px] w-full">
      <Image
        src="https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=1920&q=80"
        alt="International Homes Hero"
        fill
        className="object-cover"
        priority
      />
      <div className="absolute inset-0 bg-black bg-opacity-50" />
      <div className="absolute inset-0 flex flex-col items-center justify-center px-4">
        <div className={`text-center mb-8 ${language === 'fa' ? 'font-arabic' : ''}`}>
          <h1 className="text-4xl md:text-5xl font-bold text-white mb-4">
            {t('hero.title')}
          </h1>
          <p className="text-xl text-white">
            {t('hero.description')}
          </p>
        </div>
        <SearchBox />
      </div>
    </div>
  );
} 