'use client';

import { useEffect, useState } from 'react';
import Image from 'next/image';
import { IProperty } from '@/models/Property';
import { formatPrice } from '@/utils/format';
import { ChevronLeftIcon, ChevronRightIcon, XMarkIcon, CheckIcon } from '@heroicons/react/24/outline';

const translations = {
  en: {
    details: 'Property Details',
    bedrooms: 'Bedrooms',
    bathrooms: 'Bathrooms',
    area: 'Area',
    sqm: 'sq.m',
    price: 'Price',
    currency: 'Toman',
    propertyType: 'Property Type',
    yearBuilt: 'Year Built',
    features: 'Features',
    amenities: 'Amenities',
    location: 'Location',
    description: 'Description'
  },
  fa: {
    details: 'مشخصات ملک',
    bedrooms: 'خوابه',
    bathrooms: 'حمام',
    area: 'متراژ',
    sqm: 'متر مربع',
    price: 'قیمت',
    currency: 'تومان',
    propertyType: 'نوع ملک',
    yearBuilt: 'سال ساخت',
    features: 'ویژگی‌ها',
    amenities: 'امکانات',
    location: 'موقعیت',
    description: 'توضیحات'
  }
};

const propertyTypeTranslations = {
  en: {
    villa: 'Villa',
    apartment: 'Apartment',
    traditional: 'Traditional House'
  },
  fa: {
    villa: 'ویلا',
    apartment: 'آپارتمان',
    traditional: 'خانه سنتی'
  }
};

export default function PropertyProfile({ params }: { params: { id: string } }) {
  const [property, setProperty] = useState<IProperty | null>(null);
  const [loading, setLoading] = useState(true);
  const [galleryOpen, setGalleryOpen] = useState(false);
  const [galleryIndex, setGalleryIndex] = useState(0);
  const [checkIn, setCheckIn] = useState('');
  const [checkOut, setCheckOut] = useState('');
  const [guests, setGuests] = useState(1);
  const [language, setLanguage] = useState('fa'); // You can connect this to your language context
  const t = translations[language as keyof typeof translations];
  const dir = language === 'fa' ? 'rtl' : 'ltr';

  useEffect(() => {
    async function fetchProperty() {
      try {
        const response = await fetch(`/api/properties/${params.id}`);
        if (!response.ok) throw new Error('Failed to fetch property');
        const data = await response.json();
        setProperty(data);
      } catch (error) {
        console.error('Error fetching property:', error);
      } finally {
        setLoading(false);
      }
    }

    fetchProperty();
  }, [params.id]);

  if (loading) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="animate-spin rounded-full h-12 w-12 border-t-2 border-b-2 border-primary"></div>
      </div>
    );
  }

  if (!property) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="text-xl text-gray-600">Property not found</div>
      </div>
    );
  }

  const images = [property.mainImage, ...(property.images || [])];
  const city = property.location?.city || '';
  const address = property.location?.address || '';
  const stats = { rating: 4.8, reviewCount: 24 }; // Default stats
  const amenities = property.amenities || [];

  return (
    <div className="max-w-7xl mx-auto px-4 py-8 grid grid-cols-1 lg:grid-cols-3 gap-8">
      {/* Gallery & Main Info */}
      <div className="lg:col-span-2">
        {/* Image Gallery */}
        <div className="relative w-full aspect-[16/9] rounded-2xl overflow-hidden mb-6">
          <Image
            src={images[galleryIndex]}
            alt={property.title}
            fill
            className="object-cover"
            priority
          />
          {images.length > 1 && (
            <>
              <button onClick={() => setGalleryIndex((galleryIndex - 1 + images.length) % images.length)} className="absolute left-2 top-1/2 -translate-y-1/2 bg-white/80 rounded-full p-2 hover:bg-white z-10">
                <ChevronLeftIcon className="w-6 h-6 text-gray-800" />
              </button>
              <button onClick={() => setGalleryIndex((galleryIndex + 1) % images.length)} className="absolute right-2 top-1/2 -translate-y-1/2 bg-white/80 rounded-full p-2 hover:bg-white z-10">
                <ChevronRightIcon className="w-6 h-6 text-gray-800" />
              </button>
            </>
          )}
          <button onClick={() => setGalleryOpen(true)} className="absolute bottom-4 right-4 bg-white/90 px-4 py-2 rounded-full shadow text-gray-800 font-medium hover:bg-primary hover:text-white transition">View all images</button>
        </div>
        {/* Modal Gallery */}
        {galleryOpen && (
          <div className="fixed inset-0 bg-black/80 z-50 flex flex-col items-center justify-center">
            <button onClick={() => setGalleryOpen(false)} className="absolute top-8 right-8 bg-white/80 rounded-full p-2 hover:bg-white z-50">
              <XMarkIcon className="w-7 h-7 text-gray-800" />
            </button>
            <div className="relative w-full max-w-3xl aspect-[16/9] mb-6">
              <Image
                src={images[galleryIndex]}
                alt={property.title}
                fill
                className="object-cover rounded-xl"
              />
              {images.length > 1 && (
                <>
                  <button onClick={() => setGalleryIndex((galleryIndex - 1 + images.length) % images.length)} className="absolute left-2 top-1/2 -translate-y-1/2 bg-white/80 rounded-full p-2 hover:bg-white z-10">
                    <ChevronLeftIcon className="w-6 h-6 text-gray-800" />
                  </button>
                  <button onClick={() => setGalleryIndex((galleryIndex + 1) % images.length)} className="absolute right-2 top-1/2 -translate-y-1/2 bg-white/80 rounded-full p-2 hover:bg-white z-10">
                    <ChevronRightIcon className="w-6 h-6 text-gray-800" />
                  </button>
                </>
              )}
            </div>
            <div className="flex gap-2 flex-wrap justify-center">
              {images.map((img, idx) => (
                <button key={idx} onClick={() => setGalleryIndex(idx)} className={`w-20 h-14 rounded-lg overflow-hidden border-2 ${galleryIndex === idx ? 'border-primary' : 'border-transparent'}`}>
                  <Image src={img} alt={property.title} width={80} height={56} className="object-cover w-full h-full" />
                </button>
              ))}
            </div>
          </div>
        )}
        {/* Title, Location, Rating */}
        <div className="mb-4">
          <h1 className="text-3xl font-bold mb-2">{property.title}</h1>
          <div className="flex items-center gap-4 text-gray-600 text-lg mb-2">
            <span>{address}, {city}</span>
            <span className="flex items-center gap-1">★ {stats.rating} <span className="text-sm">({stats.reviewCount} reviews)</span></span>
          </div>
        </div>
        {/* Description */}
        <div className="mb-6">
          <h2 className="text-xl font-semibold mb-2">About this property</h2>
          <p className="text-gray-700 whitespace-pre-line">{property.description}</p>
        </div>
        {/* Amenities */}
        <div className="mb-8">
          <h2 className="text-xl font-semibold mb-4">Amenities</h2>
          <div className="grid grid-cols-2 md:grid-cols-3 gap-4">
            {amenities.map((amenity, index) => (
              <div key={index} className="flex items-center gap-2">
                <CheckIcon className="h-5 w-5 text-primary" />
                <span>{amenity}</span>
              </div>
            ))}
          </div>
        </div>
        {/* Rules & Cancellation */}
        <div className="mb-8">
          <h2 className="text-xl font-semibold mb-4">House Rules</h2>
          <ul className="space-y-2 text-gray-600">
            {property.rules?.map((rule, index) => (
              <li key={index}>{rule}</li>
            ))}
            <li>Check-in: {property.availability?.checkInTime || '15:00'}</li>
            <li>Check-out: {property.availability?.checkOutTime || '11:00'}</li>
            <li>Cancellation: {property.cancellationPolicy || 'Flexible'}</li>
          </ul>
        </div>
        {/* Map/Location */}
        <div className="mb-6">
          <h2 className="text-xl font-semibold mb-2">Location</h2>
          <div className="w-full h-64 bg-gray-200 rounded-xl flex items-center justify-center text-gray-500">
            Map Placeholder (Dubai, {address})
          </div>
        </div>
        {/* Reviews */}
        <div className="mb-6">
          <h2 className="text-xl font-semibold mb-2">Reviews</h2>
          <div className="flex items-center gap-2 mb-2">
            <span className="text-2xl font-bold text-primary">{stats.rating}</span>
            <span className="text-gray-600">({stats.reviewCount} reviews)</span>
          </div>
          <div className="space-y-2">
            <div className="bg-gray-50 p-3 rounded-lg">
              <span className="font-semibold">Ali</span>: Great stay, beautiful villa and very clean!
            </div>
            <div className="bg-gray-50 p-3 rounded-lg">
              <span className="font-semibold">Sara</span>: Amazing location and very friendly host.
            </div>
            <div className="bg-gray-50 p-3 rounded-lg">
              <span className="font-semibold">Mohammed</span>: Would definitely book again!
            </div>
          </div>
        </div>
      </div>
      {/* Booking Sidebar */}
      <aside className="bg-white rounded-2xl shadow-lg p-6 h-fit sticky top-24 flex flex-col gap-6">
        <div>
          <div className="text-2xl font-bold text-primary mb-2">{formatPrice(property.price, 'en')} AED <span className="text-base font-normal text-gray-500">/ night</span></div>
          <div className="flex flex-col gap-2 mb-4">
            <input type="date" className="input-field" value={checkIn} onChange={e => setCheckIn(e.target.value)} placeholder="Check-in" />
            <input type="date" className="input-field" value={checkOut} onChange={e => setCheckOut(e.target.value)} placeholder="Check-out" />
            <select className="input-field" value={guests} onChange={e => setGuests(Number(e.target.value))}>
              {[...Array(property.guests || 10).keys()].map(i => <option key={i+1} value={i+1}>{i+1} Guest{i+1>1?'s':''}</option>)}
            </select>
          </div>
          <button className="w-full bg-primary text-white py-3 rounded-lg font-semibold hover:bg-primary-dark transition">Reserve</button>
        </div>
        <div className="text-gray-500 text-sm">You won&apos;t be charged yet</div>
        <div className="flex flex-col gap-1 text-gray-700 text-sm">
          <div>Check-in: <span className="font-medium">{property.availability?.checkInTime || '15:00'}</span></div>
          <div>Check-out: <span className="font-medium">{property.availability?.checkOutTime || '11:00'}</span></div>
          <div>Min stay: <span className="font-medium">{property.availability?.minStay || 2} nights</span></div>
        </div>
      </aside>
    </div>
  );
} 