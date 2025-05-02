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

const mockProperties = [
  {
    id: 1,
    title: 'Luxury Villa with Eiffel Tower View',
    location: 'Paris, France',
    price: 850,
    image: '/images/cities-in-france-paris-laforet.webp',
  },
  {
    id: 2,
    title: 'Modern Apartment in Central London',
    location: 'London, UK',
    price: 400,
    image: '/images/london.jpg',
  },
  {
    id: 3,
    title: 'Beachfront Villa in Bali',
    location: 'Bali, Indonesia',
    price: 300,
    image: '/images/bali.jpg',
  },
  {
    id: 4,
    title: 'Luxury Penthouse in Manhattan',
    location: 'New York City, USA',
    price: 1200,
    image: '/images/newyork.jpg',
  },
  {
    id: 5,
    title: 'Traditional Ryokan in Tokyo',
    location: 'Tokyo, Japan',
    price: 450,
    image: '/images/tokyo.jpg',
  },
  {
    id: 6,
    title: 'Historic Apartment near Colosseum',
    location: 'Rome, Italy',
    price: 350,
    image: '/images/rome.jpg',
  },
  {
    id: 7,
    title: 'Luxury Suite with Marina View',
    location: 'Dubai, UAE',
    price: 600,
    image: '/images/dubai.jpg',
  },
  {
    id: 8,
    title: 'Riverside Apartment in Amsterdam',
    location: 'Amsterdam, Netherlands',
    price: 380,
    image: '/images/amsterdam.jpg',
  },
  {
    id: 9,
    title: 'Beachfront Villa in Santorini',
    location: 'Santorini, Greece',
    price: 550,
    image: '/images/placeholder-1.jpg.jpg',
  },
  {
    id: 10,
    title: 'Modern Loft in Barcelona',
    location: 'Barcelona, Spain',
    price: 320,
    image: '/images/barcelona.jpg',
  },
  {
    id: 11,
    title: 'Luxury Condo with Harbor View',
    location: 'Hong Kong',
    price: 480,
    image: '/images/hongkong.jpg',
  },
  {
    id: 12,
    title: 'Riverside Villa in Bangkok',
    location: 'Bangkok, Thailand',
    price: 280,
    image: '/images/bangkok.jpg',
  }
];

export default function SearchPageInner() {
  const searchParams = useSearchParams();
  const [properties, setProperties] = useState<Property[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const location = searchParams.get('location')?.toLowerCase() || '';
    const checkIn = searchParams.get('checkIn');
    const checkOut = searchParams.get('checkOut');

    // Simulate API call with setTimeout
    setTimeout(() => {
      const filteredProperties = mockProperties.filter(prop => 
        !location || 
        prop.location.toLowerCase().includes(location) ||
        prop.title.toLowerCase().includes(location)
      );

      setProperties(filteredProperties);
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