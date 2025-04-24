import Image from 'next/image';

export default function Hero() {
  return (
    <section className="relative h-[70vh] min-h-[600px]">
      <Image
        src="/images/placeholder-1.jpg.jpg"
        alt="International Homes Hero"
        fill
        className="object-cover"
        priority
      />
      <div className="absolute inset-0 bg-black/40" />
      <div className="absolute inset-0 flex flex-col items-center justify-center text-white text-center px-4">
        <h1 className="text-4xl md:text-5xl lg:text-6xl font-bold mb-6">
          Discover Your Perfect International Getaway
        </h1>
        <p className="text-xl md:text-2xl mb-8">
          Find and book unique accommodations in the world&apos;s most beautiful destinations
        </p>
        <div className="w-full max-w-4xl bg-white rounded-lg shadow-lg p-4">
          <div className="flex flex-col md:flex-row gap-4">
            <input
              type="text"
              placeholder="Search for destinations..."
              className="flex-1 p-3 rounded border text-gray-800"
            />
            <input
              type="date"
              placeholder="Check-in date"
              className="p-3 rounded border text-gray-800"
            />
            <input
              type="date"
              placeholder="Check-out date"
              className="p-3 rounded border text-gray-800"
            />
            <button className="bg-blue-600 text-white px-8 py-3 rounded hover:bg-blue-700 transition-colors">
              Search
            </button>
          </div>
        </div>
      </div>
    </section>
  );
} 