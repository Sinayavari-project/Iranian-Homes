import Image from 'next/image';
import Link from 'next/link';
import { StarIcon } from '@heroicons/react/24/solid';

interface Property {
  id: number;
  title: string;
  location: string;
  price: number;
  rating: number;
  reviews: number;
  image: string;
  features: string[];
}

const properties: Property[] = [
  {
    id: 1,
    title: 'Luxury Villa in Santorini',
    location: 'Santorini, Greece',
    price: 350,
    rating: 4.8,
    reviews: 124,
    image: '/images/placeholder-1.jpg.jpg',
    features: ['4 bedrooms', 'Private pool', 'Sea view'],
  },
  {
    id: 2,
    title: 'Modern Apartment in Barcelona',
    location: 'Barcelona, Spain',
    price: 180,
    rating: 4.9,
    reviews: 89,
    image: '/images/cities-in-france-paris-laforet.webp',
    features: ['3 bedrooms', 'Parking', 'City center'],
  },
  {
    id: 3,
    title: 'Beachfront Villa in Maldives',
    location: 'Maldives',
    price: 450,
    rating: 4.7,
    reviews: 156,
    image: '/images/images.jpg',
    features: ['2 bedrooms', 'Private beach', 'Ocean view'],
  },
  {
    id: 4,
    title: 'Mountain Lodge in Switzerland',
    location: 'Zermatt, Switzerland',
    price: 280,
    rating: 4.9,
    reviews: 112,
    image: '/images/placeholder-1.jpg.jpg',
    features: ['5 bedrooms', 'Mountain view', 'Ski-in/Ski-out'],
  },
];

export default function FeaturedProperties() {
  return (
    <section className="py-16">
      <div className="container mx-auto px-4">
        <h2 className="text-3xl font-bold text-center mb-8">Featured Properties</h2>
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
          {properties.map((property) => (
            <Link
              key={property.id}
              href={`/property/${property.id}`}
              className="group"
            >
              <div className="card">
                <div className="relative h-48">
                  <Image
                    src={property.image}
                    alt={property.title!}
                    fill
                    className="object-cover group-hover:scale-105 transition-transform duration-300"
                  />
                </div>
                <div className="p-4">
                  <div className="flex items-center justify-between mb-2">
                    <h3 className="property-title">{property.title}</h3>
                    <div className="flex items-center">
                      <StarIcon className="w-5 h-5 text-yellow-400" />
                      <span className="text-sm font-medium mr-1">
                        {property.rating}
                      </span>
                      <span className="text-sm text-gray-500">
                        ({property.reviews})
                      </span>
                    </div>
                  </div>
                  <p className="property-location mb-4">
                    {property.location}
                  </p>
                  <div className="property-features">
                    {property.features.map((feature, index) => (
                      <span key={index} className="flex items-center">
                        <span className="feature-icon">•</span>
                        {feature}
                      </span>
                    ))}
                  </div>
                  <div className="mt-4 flex items-center justify-between">
                    <span className="property-price">
                      ${property.price}/night
                    </span>
                  </div>
                </div>
              </div>
            </Link>
          ))}
        </div>
      </div>
    </section>
  );
} 