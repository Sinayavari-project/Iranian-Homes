'use client';

import { useState, useEffect } from 'react';
import { useLanguage } from '@/contexts/LanguageContext';
import PropertyCard from '@/components/properties/PropertyCard';
import { IProperty } from '@/models/Property';
import Link from 'next/link';

export default function PropertiesPage() {
  const { t, language } = useLanguage();
  const [properties, setProperties] = useState<IProperty[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [filters, setFilters] = useState({
    query: '',
    propertyType: '',
    minPrice: '',
    maxPrice: '',
    city: '',
    page: 1,
    limit: 12
  });

  useEffect(() => {
    fetchProperties();
  }, [filters]);

  const fetchProperties = async () => {
    try {
      setLoading(true);
      setError(null);

      const params = new URLSearchParams();
      Object.entries(filters).forEach(([key, value]) => {
        if (value) {
          params.append(key, value.toString());
        }
      });

      const response = await fetch(`/api/properties?${params.toString()}`);
      const data = await response.json();

      if (!response.ok) {
        throw new Error(data.error || 'Failed to fetch properties');
      }

      setProperties(data.properties || []);
    } catch (error) {
      console.error('Error fetching properties:', error);
      setError(error instanceof Error ? error.message : 'An error occurred while fetching properties');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen p-4">
      <header className="mb-8">
        <nav className="flex justify-between items-center">
          <Link href="/" className="text-2xl font-bold">
            Global Homes
          </Link>
          <div className="flex gap-4">
            <Link href="/about" className="hover:underline">
              {t('nav.about')}
            </Link>
            <Link href="/contact" className="hover:underline">
              {t('nav.contact')}
            </Link>
          </div>
        </nav>
      </header>

      <main>
        <div className="flex justify-between items-center mb-6">
          <h1 className="text-3xl font-bold">{t('properties.title')}</h1>
          <div className="flex gap-4">
            {/* Add filter controls here */}
          </div>
        </div>

        {loading ? (
          <div className="flex justify-center items-center min-h-[400px]">
            <div className="animate-spin rounded-full h-12 w-12 border-t-2 border-b-2 border-primary"></div>
          </div>
        ) : error ? (
          <div className="flex justify-center items-center min-h-[400px] text-red-500">
            {error}
          </div>
        ) : properties.length === 0 ? (
          <div className="flex justify-center items-center min-h-[400px] text-gray-500">
            {t('properties.noResults')}
          </div>
        ) : (
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
            {properties.map((property: IProperty) => (
              <PropertyCard key={property._id?.toString()} property={property} />
            ))}
          </div>
        )}
      </main>
    </div>
  );
} 