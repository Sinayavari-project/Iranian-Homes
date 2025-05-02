'use client';

import Image from 'next/image';
import Link from 'next/link';
import { IProperty } from '@/models/Property';
import { formatPrice, createWhatsAppUrl } from '@/utils/format';
import { translateLocation } from '@/utils/translations';
import { Icon, Icons } from '@/components/shared/Icons';
import { useState } from 'react';
import { ChevronLeftIcon, ChevronRightIcon } from '@heroicons/react/24/outline';

interface PropertyCardProps {
  property: IProperty;
  language?: string;
}

const translations = {
  en: {
    bedrooms: 'Bedrooms',
    bathrooms: 'Bathrooms',
    sqm: 'sq.m',
    amenities: 'Amenities',
    viewDetails: 'View Details',
    currency: 'Toman',
    reserve: 'Reserve via WhatsApp'
  },
  fa: {
    bedrooms: 'خوابه',
    bathrooms: 'حمام',
    sqm: 'متر مربع',
    amenities: 'امکانات',
    viewDetails: 'مشاهده جزئیات',
    currency: 'تومان',
    reserve: 'رزرو از طریق واتساپ'
  }
};

const propertyTitles = {
  en: {
    'Beautiful Villa in Tehran': 'Beautiful Villa in Tehran',
    'Modern Apartment in Isfahan': 'Modern Apartment in Isfahan',
    'Traditional House in Kashan': 'Traditional House in Kashan'
  },
  fa: {
    'Beautiful Villa in Tehran': 'ویلای زیبا در تهران',
    'Modern Apartment in Isfahan': 'آپارتمان مدرن در اصفهان',
    'Traditional House in Kashan': 'خانه سنتی در کاشان'
  }
};

const propertySummaries = {
  en: {
    'A luxurious villa with modern amenities': 'A luxurious villa with modern amenities',
    'Stylish apartment near historic attractions': 'Stylish apartment near historic attractions',
    'Historic house with authentic Persian architecture': 'Historic house with authentic Persian architecture'
  },
  fa: {
    'A luxurious villa with modern amenities': 'ویلای لوکس با امکانات مدرن',
    'Stylish apartment near historic attractions': 'آپارتمان شیک نزدیک جاذبه‌های تاریخی',
    'Historic house with authentic Persian architecture': 'خانه تاریخی با معماری اصیل ایرانی'
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

export default function PropertyCard({ property, language = 'en' }: PropertyCardProps) {
  const t = translations[language as keyof typeof translations];
  const dir = language === 'fa' ? 'rtl' : 'ltr';
  const [hovered, setHovered] = useState(false);
  const [imageIndex, setImageIndex] = useState(0);
  const images = [property.mainImage, ...(property.images || [])];

  const showArrows = hovered || typeof window !== 'undefined' && window.innerWidth < 768;

  const handleMouseEnter = () => {
    setHovered(true);
    if (images.length > 1) {
      setImageIndex(1);
    }
  };
  const handleMouseLeave = () => {
    setHovered(false);
    setImageIndex(0);
  };

  const nextImage = (e?: React.MouseEvent) => {
    if (e) e.stopPropagation();
    setImageIndex((prev) => (prev + 1) % images.length);
  };
  const prevImage = (e?: React.MouseEvent) => {
    if (e) e.stopPropagation();
    setImageIndex((prev) => (prev - 1 + images.length) % images.length);
  };

  return (
    <div
      className={`bg-white rounded-xl shadow-lg overflow-hidden transform transition-all duration-300 hover:shadow-2xl hover:-translate-y-1.5 cursor-pointer relative group`}
      dir={dir}
      onMouseEnter={handleMouseEnter}
      onMouseLeave={handleMouseLeave}
      style={{ maxWidth: 400, minHeight: 480 }}
    >
      <div className="relative h-64">
        <Image
          src={images[imageIndex]}
          alt={language === 'fa' ? property.titleFa : property.title}
          fill
          className="object-cover transition-all duration-500"
        />
        <div className="absolute inset-0 bg-gradient-to-t from-black/50 to-transparent" />
        {/* Price badge */}
        <div className="absolute top-4 right-4 bg-white/90 backdrop-blur-sm px-3 py-1.5 rounded-full text-primary font-bold">
          {formatPrice(property.price, language)} {t.currency}
        </div>
        {/* Carousel arrows */}
        {images.length > 1 && (
          <>
            <button
              onClick={prevImage}
              className="absolute left-2 top-1/2 -translate-y-1/2 bg-white/80 rounded-full p-1.5 opacity-0 group-hover:opacity-100 transition-opacity duration-300 hover:bg-white focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary z-10"
              style={{ opacity: hovered ? 1 : 0, pointerEvents: hovered ? 'auto' : 'none' }}
              aria-label="Previous image"
            >
              <ChevronLeftIcon className="w-5 h-5 text-gray-800" />
            </button>
            <button
              onClick={nextImage}
              className="absolute right-2 top-1/2 -translate-y-1/2 bg-white/80 rounded-full p-1.5 opacity-0 group-hover:opacity-100 transition-opacity duration-300 hover:bg-white focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary z-10"
              style={{ opacity: hovered ? 1 : 0, pointerEvents: hovered ? 'auto' : 'none' }}
              aria-label="Next image"
            >
              <ChevronRightIcon className="w-5 h-5 text-gray-800" />
            </button>
          </>
        )}
        {/* Hover overlay */}
        {hovered && (
          <div className="absolute inset-0 bg-black/30 flex items-center justify-center transition-opacity duration-300">
            <Link
              href={`/properties/${property._id}`}
              className="px-6 py-2 bg-primary text-white rounded-full font-semibold shadow-lg hover:bg-primary-dark transition-colors text-lg"
            >
              {t.viewDetails}
            </Link>
          </div>
        )}
      </div>
      <div className="p-5 flex flex-col justify-between h-[calc(100%-16rem)]">
        {/* Location */}
        <div className="flex items-center gap-1 text-gray-500 text-sm mb-2">
          <Icon icon={Icons.Location} size={16} />
          <span className="truncate">
            {translateLocation(property.location.city, 'cities', language)}, 
            {translateLocation(property.location.state, 'states', language)}
          </span>
        </div>
        {/* Title */}
        <h2 className="text-xl font-bold mb-3 text-gray-900">
          {language === 'fa' ? property.titleFa : property.title}
        </h2>
        {/* Property specs */}
        <div className="flex items-center gap-4 mb-4 text-gray-600">
          <div className="flex items-center gap-1">
            <Icon icon={Icons.Bed} size={16} className="text-primary" />
            <span>{property.bedrooms} {t.bedrooms}</span>
          </div>
          <div className="flex items-center gap-1">
            <Icon icon={Icons.Bath} size={16} className="text-primary" />
            <span>{property.bathrooms} {t.bathrooms}</span>
          </div>
          {property.area && (
            <div className="flex items-center gap-1">
              <Icon icon={Icons.Area} size={16} className="text-primary" />
              <span>{property.area} {t.sqm}</span>
            </div>
          )}
        </div>
        {/* Amenities */}
        <div className="mb-4">
          <h3 className="text-sm font-semibold mb-2 text-gray-700">{t.amenities}</h3>
          <div className="flex flex-wrap gap-2">
            {(property.amenities || []).slice(0, 3).map((amenity, index) => (
              <span
                key={index}
                className="px-2.5 py-1 bg-gray-50 text-xs rounded-lg text-gray-600"
              >
                {amenityTranslations[language as keyof typeof amenityTranslations][amenity as keyof typeof amenityTranslations.en]}
              </span>
            ))}
          </div>
        </div>
        {/* Action buttons */}
        <a
          href={createWhatsAppUrl(property, language)}
          target="_blank"
          rel="noopener noreferrer"
          className="flex items-center justify-center gap-2 w-full bg-green-500 text-white py-2.5 rounded-lg hover:bg-green-600 transition-colors font-medium mt-auto"
        >
          <Icon icon={Icons.WhatsApp} size={20} />
          {t.reserve}
        </a>
      </div>
    </div>
  );
} 