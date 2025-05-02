import Link from 'next/link';
import { useLanguage } from '@/contexts/LanguageContext';
import PropertyImageCarousel from './PropertyImageCarousel';
import { IProperty } from '@/models/Property';
import { StarIcon } from '@heroicons/react/24/outline';
import { formatPrice } from '@/utils/format';

interface PropertyCardProps {
  property: IProperty;
}

export default function PropertyCard({ property }: PropertyCardProps) {
  const allImages = [property.mainImage, ...property.images];
  const { language } = useLanguage();

  return (
    <Link href={`/properties/${property._id}`} className="block">
      <div className="bg-white rounded-lg shadow-md overflow-hidden">
        <PropertyImageCarousel images={allImages} title={property.title} />
        <div className="p-4">
          <div className="flex justify-between items-start">
            <div>
              <h3 className="font-medium text-gray-900">{property.title}</h3>
              <p className="text-sm text-gray-500">
                {property.location.address}, {property.location.city}
              </p>
              <div className="flex items-center space-x-1">
                <StarIcon className="h-4 w-4 text-yellow-400" />
                <span className="text-sm text-gray-500">4.8 (24 reviews)</span>
              </div>
            </div>
            <div className="mt-4">
              <div className="text-lg font-semibold text-gray-900">
                {formatPrice(property.price, language)}
              </div>
              <div className="text-sm text-gray-500">per night</div>
            </div>
          </div>
        </div>
      </div>
    </Link>
  );
} 