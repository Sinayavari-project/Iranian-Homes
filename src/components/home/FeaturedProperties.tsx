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
    title: 'Luxury Beachfront Villa',
    location: 'Bali, Indonesia',
    price: 450,
    rating: 4.9,
    reviews: 128,
    image: 'https://images.unsplash.com/photo-1537640538966-79f369143f8f?auto=format&fit=crop&w=800&q=80',
    features: ['4 bedrooms', 'Private pool', 'Sea view'],
  },
  {
    id: 2,
    title: 'Elegant Parisian Penthouse',
    location: 'Paris, France',
    price: 680,
    rating: 4.8,
    reviews: 96,
    image: 'https://images.unsplash.com/photo-1549877452-9c387954fbc2?auto=format&fit=crop&w=800&q=80',
    features: ['3 bedrooms', 'Parking', 'City center'],
  },
  {
    id: 3,
    title: 'Traditional Machiya House',
    location: 'Kyoto, Japan',
    price: 320,
    rating: 4.7,
    reviews: 84,
    image: 'https://images.unsplash.com/photo-1480796927426-f609979314bd?auto=format&fit=crop&w=800&q=80',
    features: ['2 bedrooms', 'Private beach', 'Ocean view'],
  },
  {
    id: 4,
    title: 'Luxury Manhattan Apartment',
    location: 'New York, USA',
    price: 890,
    rating: 4.9,
    reviews: 156,
    image: 'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?auto=format&fit=crop&w=800&q=80',
    features: ['5 bedrooms', 'Mountain view', 'Ski-in/Ski-out'],
  },
];

export default function FeaturedProperties() {
  return (
    <section className="container mx-auto px-4 py-16">
      <h2 className="text-3xl font-bold mb-8">Featured Properties</h2>
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
        {properties.map((property) => (
          <div key={property.id} className="bg-white rounded-lg shadow-lg overflow-hidden">
            <div className="relative h-48">
              <Image
                src={property.image}
                alt={property.title!}
                fill
                className="object-cover"
              />
            </div>
            <div className="p-4">
              <h3 className="text-xl font-semibold mb-2">{property.title}</h3>
              <p className="text-gray-600 mb-2">{property.location}</p>
              <div className="flex items-center mb-2">
                <span className="text-yellow-500">★</span>
                <span className="ml-1">{property.rating}</span>
                <span className="text-gray-500 ml-1">({property.reviews} reviews)</span>
              </div>
              <p className="text-lg font-bold">${property.price} <span className="text-gray-500 text-sm font-normal">per night</span></p>
            </div>
          </div>
        ))}
      </div>
    </section>
  );
} 