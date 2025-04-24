import Hero from '@/components/home/Hero';
import PopularDestinations from '@/components/home/PopularDestinations';
import FeaturedProperties from '@/components/home/FeaturedProperties';

export default function Home() {
  return (
    <div className="min-h-screen">
      <Hero />
      <PopularDestinations />
      <FeaturedProperties />
    </div>
  );
}