'use client';

import { useSearchParams } from 'next/navigation';
import { useEffect, useState } from 'react';
import Image from 'next/image';
import Link from 'next/link';

interface Property {
  id: number;
  title: string;
  location: string;
  price: number;
  image: string;
}

export default function SearchPage() {
  const searchParams = useSearchParams();
  const [properties, setProperties] = useState<Property[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    // In a real application, you would fetch properties from your API
    // For now, we'll simulate a search with mock data
    const location = searchParams.get('location')?.toLowerCase() || '';
    const checkIn = searchParams.get('checkIn');
    const checkOut = searchParams.get('checkOut');

    // Simulate API call with setTimeout
    setTimeout(() => {
      // Mock data - in a real app, this would come from your API
      const mockProperties = [
        {
          id: 1,
          title: 'Luxury Villa in Santorini',
          location: 'Santorini, Greece',
          price: 350,
          image: '/images/placeholder-1.jpg.jpg',
        },
        {
          id: 2,
          title: 'Modern Apartment in Barcelona',
          location: 'Barcelona, Spain',
          price: 180,
          image: '/images/cities-in-france-paris-laforet.webp',
        },
        // Filter properties based on location
        // In a real app, this would be done on the server
      ].filter(prop => 
        !location || 
        prop.location.toLowerCase().includes(location) ||
        prop.title.toLowerCase().includes(location)
      );

      setProperties(mockProperties);
      setLoading(false);
    }, 1000);
  }, [searchParams]);

  if (loading) {
    return (
      <div className="min-h-screen bg-gray-50 py-12 px-4 sm:px-6 lg:px-8">
        <div className="max-w-7xl mx-auto">
          <h1 className="text-3xl font-bold mb-8">Loading...</h1>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gray-50 py-12 px-4 sm:px-6 lg:px-8">
      <div className="max-w-7xl mx-auto">
        <h1 className="text-3xl font-bold mb-8">Search Results</h1>
        {properties.length === 0 ? (
          <p className="text-gray-600">No properties found matching your search criteria.</p>
        ) : (
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {properties.map((property) => (
              <Link href={`/property/${property.id}`} key={property.id} className="block">
                <div className="bg-white rounded-lg shadow-md overflow-hidden">
                  <div className="relative h-48">
                    <Image
                      src={property.image}
                      alt={property.title}
                      fill
                      className="object-cover"
                    />
                  </div>
                  <div className="p-4">
                    <h2 className="text-xl font-semibold mb-2">{property.title}</h2>
                    <p className="text-gray-600 mb-2">{property.location}</p>
                    <p className="text-blue-600 font-semibold">${property.price} / night</p>
                  </div>
                </div>
              </Link>
            ))}
          </div>
        )}
      </div>
    </div>
  );
} 