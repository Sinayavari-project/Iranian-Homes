'use client';

import { useState, useEffect } from 'react';
import { Icon, Icons } from '@/components/shared/Icons';
import { useRouter, useSearchParams } from 'next/navigation';

interface PropertyFilterProps {
  language?: string;
  onFilterChange?: (filters: FilterState) => void;
}

interface FilterState {
  propertyType: string[];
  priceRange: [number, number];
  bedrooms: number | null;
  amenities: string[];
  location: string[];
}

const translations = {
  en: {
    filters: 'Filters',
    propertyType: 'Property Type',
    price: 'Price Range',
    bedrooms: 'Bedrooms',
    amenities: 'Amenities',
    location: 'Location',
    apply: 'Apply Filters',
    reset: 'Reset',
    any: 'Any',
    min: 'Min',
    max: 'Max',
    currency: 'Toman'
  },
  fa: {
    filters: 'فیلترها',
    propertyType: 'نوع ملک',
    price: 'محدوده قیمت',
    bedrooms: 'تعداد اتاق',
    amenities: 'امکانات',
    location: 'موقعیت',
    apply: 'اعمال فیلترها',
    reset: 'پاک کردن',
    any: 'همه',
    min: 'حداقل',
    max: 'حداکثر',
    currency: 'تومان'
  }
};

const propertyTypes = {
  en: [
    { value: 'villa', label: 'Villa' },
    { value: 'apartment', label: 'Apartment' },
    { value: 'traditional', label: 'Traditional House' }
  ],
  fa: [
    { value: 'villa', label: 'ویلا' },
    { value: 'apartment', label: 'آپارتمان' },
    { value: 'traditional', label: 'خانه سنتی' }
  ]
};

const amenityOptions = {
  en: [
    { value: 'WiFi', label: 'WiFi' },
    { value: 'Air Conditioning', label: 'Air Conditioning' },
    { value: 'Parking', label: 'Parking' },
    { value: 'Pool', label: 'Pool' },
    { value: 'Garden', label: 'Garden' }
  ],
  fa: [
    { value: 'WiFi', label: 'وای‌فای' },
    { value: 'Air Conditioning', label: 'تهویه مطبوع' },
    { value: 'Parking', label: 'پارکینگ' },
    { value: 'Pool', label: 'استخر' },
    { value: 'Garden', label: 'باغ' }
  ]
};

const locations = {
  en: [
    { value: 'Tehran', label: 'Tehran' },
    { value: 'Isfahan', label: 'Isfahan' },
    { value: 'Kashan', label: 'Kashan' }
  ],
  fa: [
    { value: 'Tehran', label: 'تهران' },
    { value: 'Isfahan', label: 'اصفهان' },
    { value: 'Kashan', label: 'کاشان' }
  ]
};

const defaultFilters: FilterState = {
  propertyType: [] as string[],
  priceRange: [0, 10000000000] as [number, number],
  bedrooms: null,
  amenities: [] as string[],
  location: [] as string[]
};

export default function PropertyFilter({ language = 'en', onFilterChange }: PropertyFilterProps) {
  const router = useRouter();
  const searchParams = useSearchParams();
  const t = translations[language as keyof typeof translations];
  const dir = language === 'fa' ? 'rtl' : 'ltr';

  const [isOpen, setIsOpen] = useState(false);
  const [filters, setFilters] = useState<FilterState>(defaultFilters);

  useEffect(() => {
    // Initialize filters from URL params
    const propertyType = searchParams.get('type')?.split(',') || [];
    const minPrice = Number(searchParams.get('minPrice')) || 0;
    const maxPrice = Number(searchParams.get('maxPrice')) || 10000000000;
    const bedrooms = searchParams.get('bedrooms') ? Number(searchParams.get('bedrooms')) : null;
    const amenities = searchParams.get('amenities')?.split(',') || [];
    const location = searchParams.get('location')?.split(',') || [];

    setFilters({
      propertyType: propertyType as string[],
      priceRange: [minPrice, maxPrice] as [number, number],
      bedrooms,
      amenities: amenities as string[],
      location: location as string[]
    });
  }, [searchParams]);

  const handleFilterChange = (newFilters: FilterState) => {
    setFilters(newFilters);
    onFilterChange?.(newFilters);

    // Update URL params
    const params = new URLSearchParams();
    if (newFilters.propertyType.length) params.set('type', newFilters.propertyType.join(','));
    if (newFilters.priceRange[0] > 0) params.set('minPrice', newFilters.priceRange[0].toString());
    if (newFilters.priceRange[1] < 10000000000) params.set('maxPrice', newFilters.priceRange[1].toString());
    if (newFilters.bedrooms) params.set('bedrooms', newFilters.bedrooms.toString());
    if (newFilters.amenities.length) params.set('amenities', newFilters.amenities.join(','));
    if (newFilters.location.length) params.set('location', newFilters.location.join(','));

    router.push(`?${params.toString()}`);
  };

  const handleReset = () => {
    setFilters(defaultFilters);
    onFilterChange?.(defaultFilters);
    router.push('');
  };

  return (
    <div className="bg-white rounded-xl shadow-lg p-4" dir={dir}>
      <div className="flex items-center justify-between mb-4">
        <h2 className="text-xl font-semibold">{t.filters}</h2>
        <button
          onClick={() => setIsOpen(!isOpen)}
          className="lg:hidden p-2 hover:bg-gray-100 rounded-lg transition-colors"
        >
          <Icon icon={Icons.Menu} size={20} />
        </button>
      </div>

      <div className={`space-y-6 ${isOpen ? 'block' : 'hidden lg:block'}`}>
        {/* Property Type */}
        <div>
          <h3 className="font-medium mb-2">{t.propertyType}</h3>
          <div className="space-y-2">
            {propertyTypes[language as keyof typeof propertyTypes].map((type) => (
              <label key={type.value} className="flex items-center gap-2">
                <input
                  type="checkbox"
                  checked={filters.propertyType.includes(type.value)}
                  onChange={(e) => {
                    const newTypes = e.target.checked
                      ? [...filters.propertyType, type.value]
                      : filters.propertyType.filter(t => t !== type.value);
                    handleFilterChange({ ...filters, propertyType: newTypes });
                  }}
                  className="rounded text-primary focus:ring-primary"
                />
                <span>{type.label}</span>
              </label>
            ))}
          </div>
        </div>

        {/* Price Range */}
        <div>
          <h3 className="font-medium mb-2">{t.price}</h3>
          <div className="grid grid-cols-2 gap-2">
            <div>
              <label className="text-sm text-gray-500">{t.min}</label>
              <input
                type="number"
                value={filters.priceRange[0] || ''}
                onChange={(e) => {
                  const value = Number(e.target.value);
                  handleFilterChange({
                    ...filters,
                    priceRange: [value, filters.priceRange[1]]
                  });
                }}
                className="w-full p-2 border rounded-lg focus:ring-primary focus:border-primary"
              />
            </div>
            <div>
              <label className="text-sm text-gray-500">{t.max}</label>
              <input
                type="number"
                value={filters.priceRange[1] === 10000000000 ? '' : filters.priceRange[1]}
                onChange={(e) => {
                  const value = Number(e.target.value);
                  handleFilterChange({
                    ...filters,
                    priceRange: [filters.priceRange[0], value]
                  });
                }}
                className="w-full p-2 border rounded-lg focus:ring-primary focus:border-primary"
              />
            </div>
          </div>
        </div>

        {/* Bedrooms */}
        <div>
          <h3 className="font-medium mb-2">{t.bedrooms}</h3>
          <select
            value={filters.bedrooms || ''}
            onChange={(e) => {
              const value = e.target.value ? Number(e.target.value) : null;
              handleFilterChange({ ...filters, bedrooms: value });
            }}
            className="w-full p-2 border rounded-lg focus:ring-primary focus:border-primary"
          >
            <option value="">{t.any}</option>
            {[1, 2, 3, 4, 5].map((num) => (
              <option key={num} value={num}>{num}+</option>
            ))}
          </select>
        </div>

        {/* Amenities */}
        <div>
          <h3 className="font-medium mb-2">{t.amenities}</h3>
          <div className="space-y-2">
            {amenityOptions[language as keyof typeof amenityOptions].map((amenity) => (
              <label key={amenity.value} className="flex items-center gap-2">
                <input
                  type="checkbox"
                  checked={filters.amenities.includes(amenity.value)}
                  onChange={(e) => {
                    const newAmenities = e.target.checked
                      ? [...filters.amenities, amenity.value]
                      : filters.amenities.filter(a => a !== amenity.value);
                    handleFilterChange({ ...filters, amenities: newAmenities });
                  }}
                  className="rounded text-primary focus:ring-primary"
                />
                <span>{amenity.label}</span>
              </label>
            ))}
          </div>
        </div>

        {/* Location */}
        <div>
          <h3 className="font-medium mb-2">{t.location}</h3>
          <div className="space-y-2">
            {locations[language as keyof typeof locations].map((loc) => (
              <label key={loc.value} className="flex items-center gap-2">
                <input
                  type="checkbox"
                  checked={filters.location.includes(loc.value)}
                  onChange={(e) => {
                    const newLocations = e.target.checked
                      ? [...filters.location, loc.value]
                      : filters.location.filter(l => l !== loc.value);
                    handleFilterChange({ ...filters, location: newLocations });
                  }}
                  className="rounded text-primary focus:ring-primary"
                />
                <span>{loc.label}</span>
              </label>
            ))}
          </div>
        </div>

        {/* Reset button */}
        <button
          onClick={handleReset}
          className="w-full py-2 text-gray-600 hover:text-gray-800 transition-colors"
        >
          {t.reset}
        </button>
      </div>
    </div>
  );
} 