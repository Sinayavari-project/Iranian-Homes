import Image from 'next/image';
import Link from 'next/link';

const destinations = [
  {
    id: 1,
    name: 'Paris, France',
    image: '/images/cities-in-france-paris-laforet.webp',
    properties: 1250,
  },
  {
    id: 2,
    name: 'London, UK',
    image: '/images/london.jpg',
    properties: 1480,
  },
  {
    id: 3,
    name: 'Dubai, UAE',
    image: '/images/dubai.jpg',
    properties: 980,
  },
  {
    id: 4,
    name: 'New York City, USA',
    image: '/images/newyork.jpg',
    properties: 2100,
  },
  {
    id: 5,
    name: 'Bangkok, Thailand',
    image: '/images/bangkok.jpg',
    properties: 850,
  },
  {
    id: 6,
    name: 'Singapore',
    image: '/images/singapore.jpg',
    properties: 720,
  },
  {
    id: 7,
    name: 'Tokyo, Japan',
    image: '/images/tokyo.jpg',
    properties: 1650,
  },
  {
    id: 8,
    name: 'Rome, Italy',
    image: '/images/rome.jpg',
    properties: 890,
  },
  {
    id: 9,
    name: 'Barcelona, Spain',
    image: '/images/barcelona.jpg',
    properties: 760,
  },
  {
    id: 10,
    name: 'Amsterdam, Netherlands',
    image: '/images/amsterdam.jpg',
    properties: 680,
  },
  {
    id: 11,
    name: 'Istanbul, Turkey',
    image: '/images/istanbul.jpg',
    properties: 920,
  },
  {
    id: 12,
    name: 'Hong Kong',
    image: '/images/hongkong.jpg',
    properties: 1100,
  },
  {
    id: 13,
    name: 'Seoul, South Korea',
    image: '/images/seoul.jpg',
    properties: 780,
  },
  {
    id: 14,
    name: 'Venice, Italy',
    image: '/images/venice.jpg',
    properties: 540,
  },
  {
    id: 15,
    name: 'Las Vegas, USA',
    image: '/images/lasvegas.jpg',
    properties: 890,
  },
  {
    id: 16,
    name: 'Vienna, Austria',
    image: '/images/vienna.jpg',
    properties: 620,
  },
  {
    id: 17,
    name: 'Prague, Czech Republic',
    image: '/images/prague.jpg',
    properties: 580,
  },
  {
    id: 18,
    name: 'Santorini, Greece',
    image: '/images/placeholder-1.jpg.jpg',
    properties: 450,
  },
  {
    id: 19,
    name: 'Bali, Indonesia',
    image: '/images/bali.jpg',
    properties: 920,
  },
  {
    id: 20,
    name: 'Sydney, Australia',
    image: '/images/sydney.jpg',
    properties: 680,
  },
];

export default function PopularDestinations() {
  return (
    <section className="py-16 bg-gray-50">
      <div className="container mx-auto px-4">
        <h2 className="text-3xl font-bold text-center mb-8">Popular Destinations</h2>
        <div className="grid grid-cols-1 md:grid-cols-3 lg:grid-cols-4 gap-6">
          {destinations.map((destination) => (
            <Link
              key={destination.id}
              href={`/search?location=${encodeURIComponent(destination.name)}`}
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