'use client';

import Image from 'next/image';
import { IProperty } from '@/models/Property';
import { formatPrice, createWhatsAppUrl } from '@/utils/format';
import { translateLocation } from '@/utils/translations';
import { Icon, Icons } from '@/components/shared/Icons';
import ImageGallery from '@/components/shared/ImageGallery';

interface PropertyDetailsProps {
  property: IProperty;
  language?: string;
}

const translations = {
  en: {
    details: 'Property Details',
    price: 'Price',
    currency: 'Toman',
    propertyType: 'Property Type',
    bedrooms: 'Bedrooms',
    bathrooms: 'Bathrooms',
    area: 'Area',
    sqm: 'sq.m',
    yearBuilt: 'Year Built',
    features: 'Features',
    amenities: 'Amenities',
    location: 'Location',
    description: 'Description',
    reserve: 'Reserve via WhatsApp',
    rules: 'House Rules',
    cancellation: 'Cancellation Policy'
  },
  fa: {
    details: 'جزئیات ملک',
    price: 'قیمت',
    currency: 'تومان',
    propertyType: 'نوع ملک',
    bedrooms: 'خوابه',
    bathrooms: 'حمام',
    area: 'متراژ',
    sqm: 'متر مربع',
    yearBuilt: 'سال ساخت',
    features: 'ویژگی‌ها',
    amenities: 'امکانات',
    location: 'موقعیت',
    description: 'توضیحات',
    reserve: 'رزرو از طریق واتساپ',
    rules: 'قوانین خانه',
    cancellation: 'شرایط کنسلی'
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

const featureTranslations = {
  en: {
    'Private Pool': 'Private Pool',
    'Garden': 'Garden',
    'Modern Kitchen': 'Modern Kitchen',
    'Security System': 'Security System',
    'City View': 'City View',
    'Balcony': 'Balcony',
    'Modern Appliances': 'Modern Appliances',
    'Courtyard': 'Courtyard',
    'Traditional Architecture': 'Traditional Architecture'
  },
  fa: {
    'Private Pool': 'استخر خصوصی',
    'Garden': 'باغ',
    'Modern Kitchen': 'آشپزخانه مدرن',
    'Security System': 'سیستم امنیتی',
    'City View': 'منظره شهر',
    'Balcony': 'بالکن',
    'Modern Appliances': 'لوازم خانگی مدرن',
    'Courtyard': 'حیاط',
    'Traditional Architecture': 'معماری سنتی'
  }
};

const amenityTranslations = {
  en: {
    'WiFi': 'WiFi',
    'Air Conditioning': 'Air Conditioning',
    'Parking': 'Parking',
    'BBQ': 'BBQ',
    'Private Pool': 'Private Pool',
    'Garden': 'Garden',
    'Modern Kitchen': 'Modern Kitchen',
    'Security System': 'Security System',
    'Elevator': 'Elevator',
    'Gym': 'Gym',
    'Traditional Kitchen': 'Traditional Kitchen'
  },
  fa: {
    'WiFi': 'وای‌فای',
    'Air Conditioning': 'تهویه مطبوع',
    'Parking': 'پارکینگ',
    'BBQ': 'باربیکیو',
    'Private Pool': 'استخر خصوصی',
    'Garden': 'باغ',
    'Modern Kitchen': 'آشپزخانه مدرن',
    'Security System': 'سیستم امنیتی',
    'Elevator': 'آسانسور',
    'Gym': 'باشگاه',
    'Traditional Kitchen': 'آشپزخانه سنتی'
  }
};

export default function PropertyDetails({ property, language = 'en' }: PropertyDetailsProps) {
  const t = translations[language as keyof typeof translations];
  const dir = language === 'fa' ? 'rtl' : 'ltr';

  return (
    <div className="max-w-7xl mx-auto px-4 py-8" dir={dir}>
      {/* Header */}
      <div className="mb-8">
        <h1 className="text-2xl md:text-4xl font-bold mb-4 text-gray-900">
          {language === 'fa' ? property.titleFa : property.title}
        </h1>
        <div className="flex items-center gap-2 text-gray-600">
          <Icon icon={Icons.Location} size={20} />
          <span>
            {translateLocation(property.location.address.split(',')[0], 'areas', language)}, 
            {translateLocation(property.location.city, 'cities', language)}
          </span>
        </div>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
        {/* Main Content */}
        <div className="lg:col-span-2 space-y-8">
          {/* Image Gallery */}
          <div className="bg-white rounded-2xl overflow-hidden shadow-lg">
            <ImageGallery
              images={property.images}
              mainImage={property.mainImage}
              title={language === 'fa' ? property.titleFa : property.title}
            />
          </div>

          {/* Mobile Price (shown only on mobile) */}
          <div className="lg:hidden bg-white rounded-2xl p-6 shadow-lg">
            <div className="mb-4">
              <div className="text-sm text-gray-500 mb-1">{t.price}</div>
              <div className="text-3xl font-bold text-primary">
                {formatPrice(property.price, language)} {t.currency}
              </div>
            </div>
            <a
              href={createWhatsAppUrl(property, language)}
              target="_blank"
              rel="noopener noreferrer"
              className="flex items-center justify-center gap-2 w-full bg-green-500 text-white py-3 px-6 rounded-xl hover:bg-green-600 transition-colors font-medium text-lg"
            >
              <Icon icon={Icons.WhatsApp} size={24} />
              {t.reserve}
            </a>
          </div>

          {/* Property Specs */}
          <div className="bg-white rounded-2xl p-6 shadow-lg">
            <h2 className="text-xl md:text-2xl font-bold mb-6">{t.details}</h2>
            <div className="grid grid-cols-2 md:grid-cols-4 gap-6">
              <div className="flex items-center gap-3">
                <div className="p-3 bg-primary/10 rounded-full">
                  <Icon icon={Icons.Bed} size={20} className="text-primary" />
                </div>
                <div>
                  <div className="text-sm text-gray-500">{t.bedrooms}</div>
                  <div className="font-semibold">{property.bedrooms}</div>
                </div>
              </div>
              <div className="flex items-center gap-3">
                <div className="p-3 bg-primary/10 rounded-full">
                  <Icon icon={Icons.Bath} size={20} className="text-primary" />
                </div>
                <div>
                  <div className="text-sm text-gray-500">{t.bathrooms}</div>
                  <div className="font-semibold">{property.bathrooms}</div>
                </div>
              </div>
              <div className="flex items-center gap-3">
                <div className="p-3 bg-primary/10 rounded-full">
                  <Icon icon={Icons.Area} size={20} className="text-primary" />
                </div>
                <div>
                  <div className="text-sm text-gray-500">{t.area}</div>
                  <div className="font-semibold">{property.area} {t.sqm}</div>
                </div>
              </div>
              <div className="flex items-center gap-3">
                <div className="p-3 bg-primary/10 rounded-full">
                  <Icon icon={Icons.House} size={20} className="text-primary" />
                </div>
                <div>
                  <div className="text-sm text-gray-500">{t.propertyType}</div>
                  <div className="font-semibold">
                    {propertyTypeTranslations[language as keyof typeof propertyTypeTranslations][property.propertyType as keyof typeof propertyTypeTranslations.en]}
                  </div>
                </div>
              </div>
            </div>
          </div>

          {/* Description */}
          <div className="bg-white rounded-2xl p-6 shadow-lg">
            <h2 className="text-xl md:text-2xl font-bold mb-4">{t.description}</h2>
            <p className="text-gray-600 leading-relaxed">
              {language === 'fa' ? property.descriptionFa : property.description}
            </p>
          </div>

          {/* Amenities */}
          <div className="bg-white rounded-2xl p-6 shadow-lg">
            <h2 className="text-xl md:text-2xl font-bold mb-6">{t.amenities}</h2>
            <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-4">
              {property.amenities.map((amenity, index) => (
                <div 
                  key={index} 
                  className="flex items-center gap-2 p-3 bg-gray-50 rounded-xl hover:bg-gray-100 transition-colors"
                >
                  <span className="text-gray-700">
                    {amenityTranslations[language as keyof typeof amenityTranslations][amenity as keyof typeof amenityTranslations.en]}
                  </span>
                </div>
              ))}
            </div>
          </div>
        </div>

        {/* Sidebar */}
        <div className="hidden lg:block">
          <div className="sticky top-8">
            <div className="bg-white rounded-2xl p-6 shadow-lg">
              <div className="mb-6">
                <div className="text-sm text-gray-500 mb-1">{t.price}</div>
                <div className="text-3xl font-bold text-primary">
                  {formatPrice(property.price, language)} {t.currency}
                </div>
              </div>

              {property.yearBuilt && (
                <div className="flex items-center gap-2 mb-6">
                  <Icon icon={Icons.Calendar} size={16} className="text-gray-400" />
                  <span className="text-gray-600">
                    {t.yearBuilt}: {property.yearBuilt}
                  </span>
                </div>
              )}

              <a
                href={createWhatsAppUrl(property, language)}
                target="_blank"
                rel="noopener noreferrer"
                className="flex items-center justify-center gap-2 w-full bg-green-500 text-white py-3 px-6 rounded-xl hover:bg-green-600 transition-colors font-medium text-lg"
              >
                <Icon icon={Icons.WhatsApp} size={24} />
                {t.reserve}
              </a>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
} 