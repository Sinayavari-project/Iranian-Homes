'use client';

import { useState, useEffect } from 'react';
import { useLanguage } from '@/contexts/LanguageContext';
import SearchBox from '@/components/common/SearchBox';
import PropertyCard from '@/components/properties/PropertyCard';
import { IProperty } from '@/models/Property';
import Link from 'next/link';
import Image from 'next/image';

const heroBg = 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=1500&q=80';

const categories = [
  { icon: '🏠', label: { en: 'Villas', fa: 'ویلاها' } },
  { icon: '🏢', label: { en: 'Apartments', fa: 'آپارتمان‌ها' } },
  { icon: '🏕️', label: { en: 'Eco-lodges', fa: 'اقامتگاه بوم‌گردی' } },
  { icon: '🏨', label: { en: 'Hotels', fa: 'هتل‌ها' } },
  { icon: '🏡', label: { en: 'Traditional Houses', fa: 'خانه‌های سنتی' } },
  { icon: '🏖️', label: { en: 'Beach Houses', fa: 'خانه‌های ساحلی' } },
];

export default function Home() {
  const { t, language, setLanguage } = useLanguage();
  const [properties, setProperties] = useState<IProperty[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    fetchProperties();
  }, []);

  const fetchProperties = async () => {
    try {
      setLoading(true);
      setError(null);
      const response = await fetch('/api/properties?limit=10');
      const data = await response.json();
      setProperties(data.properties || []);
    } catch (error) {
      setError('Failed to load properties');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Hero Section */}
      <section className="relative h-[480px] w-full flex items-center justify-center">
        <Image
          src={heroBg}
          alt="Rentoro Hero"
          fill
          className="object-cover"
          priority
        />
        <div className="absolute inset-0 bg-gradient-to-b from-black/60 to-black/20" />
        <div className="relative z-10 flex flex-col items-center w-full px-4">
          <div className="flex items-center gap-4 mb-6">
            <Image src="/logo.jpeg" alt="Rentoro Logo" width={56} height={56} className="rounded-full shadow-lg" />
            <h1 className="text-4xl md:text-5xl font-bold text-white drop-shadow-lg">Rentoro</h1>
          </div>
          <p className="text-xl md:text-2xl text-white mb-8 text-center drop-shadow">
            {language === 'en' ? 'Book unique stays and homes across Iran and beyond' : 'رزرو اقامتگاه‌های خاص در سراسر ایران و جهان'}
          </p>
          <div className="w-full max-w-2xl">
            <SearchBox />
          </div>
        </div>
      </section>

      {/* Categories */}
      <section className="max-w-5xl mx-auto px-4 py-8">
        <div className="flex gap-4 overflow-x-auto pb-2">
          {categories.map((cat, idx) => (
            <button
              key={idx}
              className="flex flex-col items-center p-4 min-w-[100px] bg-white rounded-xl shadow hover:bg-blue-50 transition"
            >
              <span className="text-3xl mb-2">{cat.icon}</span>
              <span className="text-sm font-medium text-gray-700">{cat.label[language]}</span>
            </button>
          ))}
        </div>
      </section>

      {/* Featured Properties */}
      <section className="max-w-7xl mx-auto px-4 py-8">
        <h2 className="text-2xl font-bold mb-6 text-gray-800">
          {language === 'en' ? 'Featured Stays' : 'اقامتگاه‌های ویژه'}
        </h2>
        {loading ? (
          <div className="flex justify-center items-center min-h-[200px]">
            <div className="animate-spin rounded-full h-10 w-10 border-t-2 border-b-2 border-blue-500"></div>
          </div>
        ) : error ? (
          <div className="text-red-500 text-center">{error}</div>
        ) : (
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
            {properties.map((property, idx) => (
              <PropertyCard key={property._id?.toString() || property.id || idx} property={property} language={language} />
            ))}
          </div>
        )}
      </section>
    </div>
  );
}