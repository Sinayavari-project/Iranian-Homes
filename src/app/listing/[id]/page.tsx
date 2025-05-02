'use client';

import { useParams } from 'next/navigation';
import PhotoGallery from '@/components/common/PhotoGallery';
import { useLanguage } from '@/contexts/LanguageContext';

// Mock data - In a real app, this would come from an API
const mockListing = {
  id: '1',
  title: 'Beautiful Villa in Tehran',
  description: 'A stunning villa with modern amenities, located in the heart of Tehran. Perfect for families and groups looking for a comfortable stay.',
  images: [
    '/images/listings/villa1.jpg',
    '/images/listings/villa2.jpg',
    '/images/listings/villa3.jpg',
    '/images/listings/villa4.jpg',
  ],
  price: 150,
  location: 'Tehran, Iran',
  amenities: ['WiFi', 'Parking', 'Kitchen', 'Air Conditioning', 'Pool'],
  bedrooms: 3,
  bathrooms: 2,
  guests: 6,
};

export default function ListingPage() {
  const { t } = useLanguage();
  const params = useParams();
  const listing = mockListing; // In a real app, fetch based on params.id

  return (
    <div className="container mx-auto px-4 py-8">
      <div className="max-w-4xl mx-auto">
        <h1 className="text-3xl font-bold mb-4">{listing.title}</h1>
        
        <div className="mb-8">
          <PhotoGallery images={listing.images} title={listing.title} />
        </div>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
          <div className="md:col-span-2">
            <div className="mb-6">
              <h2 className="text-2xl font-semibold mb-4">{t('listing.description')}</h2>
              <p className="text-gray-700">{listing.description}</p>
            </div>

            <div className="mb-6">
              <h2 className="text-2xl font-semibold mb-4">{t('listing.amenities')}</h2>
              <div className="grid grid-cols-2 gap-4">
                {listing.amenities.map((amenity, index) => (
                  <div key={index} className="flex items-center">
                    <span className="mr-2">✓</span>
                    <span>{amenity}</span>
                  </div>
                ))}
              </div>
            </div>
          </div>

          <div className="md:col-span-1">
            <div className="border rounded-xl p-6 shadow-lg">
              <div className="flex justify-between items-center mb-4">
                <span className="text-2xl font-bold">${listing.price}</span>
                <span className="text-gray-600">/ night</span>
              </div>

              <div className="grid grid-cols-3 gap-4 mb-6 text-center">
                <div>
                  <div className="font-semibold">{listing.bedrooms}</div>
                  <div className="text-sm text-gray-600">{t('listing.bedrooms')}</div>
                </div>
                <div>
                  <div className="font-semibold">{listing.bathrooms}</div>
                  <div className="text-sm text-gray-600">{t('listing.bathrooms')}</div>
                </div>
                <div>
                  <div className="font-semibold">{listing.guests}</div>
                  <div className="text-sm text-gray-600">{t('listing.guests')}</div>
                </div>
              </div>

              <button className="w-full bg-primary text-white py-3 rounded-lg hover:bg-blue-700 transition-colors">
                {t('listing.bookNow')}
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
} 