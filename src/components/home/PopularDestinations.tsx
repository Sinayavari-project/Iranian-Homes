import Image from 'next/image';
import Link from 'next/link';

const destinations = [
  {
    id: 1,
    name: 'Paris, France',
    image: 'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?auto=format&fit=crop&w=800&q=80',
    properties: 1250,
  },
  {
    id: 2,
    name: 'Bali, Indonesia',
    image: 'https://images.unsplash.com/photo-1558005530-a7958896ec60?auto=format&fit=crop&w=800&q=80',
    properties: 983,
  },
  {
    id: 3,
    name: 'Tokyo, Japan',
    image: 'https://images.unsplash.com/photo-1536098561742-ca998e48cbcc?auto=format&fit=crop&w=800&q=80',
    properties: 1432,
  },
  {
    id: 4,
    name: 'New York, USA',
    image: 'https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?auto=format&fit=crop&w=800&q=80',
    properties: 2156,
  },
  {
    id: 5,
    name: 'Rome, Italy',
    image: 'https://images.unsplash.com/photo-1552832230-c0197dd311b5?auto=format&fit=crop&w=800&q=80',
    properties: 867,
  },
  {
    id: 6,
    name: 'Dubai, UAE',
    image: 'https://images.unsplash.com/photo-1512453979798-5ea266f8880c?auto=format&fit=crop&w=800&q=80',
    properties: 1543,
  },
];

export default function PopularDestinations() {
  return (
    <section className="container mx-auto px-4 py-16">
      <h2 className="text-3xl font-bold mb-8">Popular Destinations</h2>
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
        {destinations.map((destination) => (
          <div key={destination.id} className="relative h-64 rounded-lg overflow-hidden group">
            <Image
              src={destination.image}
              alt={destination.name}
              fill
              className="object-cover transition-transform duration-300 group-hover:scale-110"
            />
            <div className="absolute inset-0 bg-black bg-opacity-40 transition-opacity duration-300 group-hover:bg-opacity-30" />
            <div className="absolute bottom-0 left-0 p-6 text-white">
              <h3 className="text-2xl font-bold mb-2">{destination.name}</h3>
              <p>{destination.properties} properties</p>
            </div>
          </div>
        ))}
      </div>
    </section>
  );
} 