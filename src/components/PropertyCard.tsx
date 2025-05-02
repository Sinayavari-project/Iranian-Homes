import Link from 'next/link';
import { HeartIcon } from '@heroicons/react/24/outline';
import { StarIcon } from '@heroicons/react/24/solid';
import PropertyImageCarousel from './PropertyImageCarousel';
import { IProperty } from '@/models/Property';

interface PropertyCardProps {
  property: IProperty;
}

export default function PropertyCard({ property }: PropertyCardProps) {
  const allImages = [property.mainImage, ...property.images];
  
  // Format price in Toman with commas
  const formatPrice = (price: number) => {
    const inToman = price / 10000; // Convert from Rial to Toman
    return new Intl.NumberFormat('fa-IR').format(inToman);
  };

  return (
    <div className="group">
      <div className="relative">
        <PropertyImageCarousel images={allImages} title={property.title} />
        
        {/* Favorite Button */}
        <button
          className="absolute top-3 right-3 z-10 p-2 rounded-full bg-white/80 
                   hover:bg-white transition-colors duration-200"
          aria-label="Add to favorites"
        >
          <HeartIcon className="w-5 h-5 text-gray-700" />
        </button>
      </div>

      <Link href={`/properties/${property._id}`}>
        <div className="mt-3 space-y-1">
          <div className="flex justify-between items-start">
            <div>
              <h3 className="font-medium text-gray-900">{property.title}</h3>
              <p className="text-sm text-gray-500">
                {property.location.neighborhood}, {property.location.city}
              </p>
            </div>
            <div className="flex items-center space-x-1">
              <StarIcon className="w-4 h-4 text-primary" />
              <span className="text-sm text-gray-700">
                {property.stats.rating}
                <span className="text-gray-500">
                  ({property.stats.reviewCount})
                </span>
              </span>
            </div>
          </div>
          
          <p className="text-gray-900">
            <span className="font-medium">{formatPrice(property.pricing.basePrice)} تومان</span>
            <span className="text-sm text-gray-500"> / شب</span>
          </p>
        </div>
      </Link>
    </div>
  );
} 