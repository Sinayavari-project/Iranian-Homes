import Image from 'next/image';
import Link from 'next/link';

const destinations = [
  {
    id: 1,
    name: 'Paris, France',
    image: '/destinations/paris.jpg',
    properties: 1250,
  },
  {
    id: 2,
    name: 'Bali, Indonesia',
    image: '/destinations/bali.jpg',
    properties: 850,
  },
  {
    id: 3,
    name: 'Tokyo, Japan',
    image: '/destinations/tokyo.jpg',
    properties: 2100,
  },
  {
    id: 4,
    name: 'New York, USA',
    image: '/destinations/newyork.jpg',
    properties: 750,
  },
  {
    id: 5,
    name: 'Rome, Italy',
    image: '/destinations/rome.jpg',
    properties: 680,
  },
  {
    id: 6,
    name: 'Dubai, UAE',
    image: '/destinations/dubai.jpg',
    properties: 420,
  },
];

export default function PopularDestinations() {
  return (
    <section className="py-16 bg-gray-50">
      <div className="container mx-auto px-4">
        <h2 className="text-3xl font-bold text-center mb-8">Popular Destinations</h2>
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {destinations.map((destination) => (
            <Link
              key={destination.id}
              href={`/properties/${destination.name}`}
              className="group"
            >
              <div className="relative h-64 rounded-xl overflow-hidden">
                <Image
                  src={destination.image}
                  alt={destination.name}
                  fill
                  className="object-cover group-hover:scale-105 transition-transform duration-300"
                />
                <div className="absolute inset-0 bg-gradient-to-t from-black/60 to-transparent" />
                <div className="absolute bottom-0 left-0 right-0 p-4">
                  <h3 className="text-xl font-bold text-white mb-1">
                    {destination.name}
                  </h3>
                  <p className="text-white/90">
                    {destination.properties} properties
                  </p>
                </div>
              </div>
            </Link>
          ))}
        </div>
      </div>
    </section>
  );
} 