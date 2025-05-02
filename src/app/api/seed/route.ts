import { NextResponse } from 'next/server';
import connectDB from '@/lib/mongodb';
import Property from '@/models/Property';

export async function GET(request: Request) {
  try {
    await connectDB();
    console.log('Connected to MongoDB in seed route');

    const { searchParams } = new URL(request.url);
    const force = searchParams.get('force') === 'true';

    // Check if we already have properties
    const count = await Property.countDocuments();
    if (count > 0 && !force) {
      return NextResponse.json({ message: 'Database already seeded' });
    }

    // Clear existing properties if force is true
    if (force) {
      await Property.deleteMany({});
      console.log('Cleared existing properties');
    }

    // Create test properties
    const testProperties = [
      {
        title: 'Beautiful Villa in Tehran',
        titleFa: 'ویلای زیبا در تهران',
        summary: 'A luxurious villa with modern amenities',
        summaryFa: 'ویلای لوکس با امکانات مدرن',
        description: 'Experience luxury living in this beautiful villa located in the heart of Tehran.',
        descriptionFa: 'تجربه زندگی لوکس در این ویلای زیبا در قلب تهران.',
        price: 2500000,
        propertyType: 'villa',
        status: 'available',
        location: {
          address: 'Niavaran, North Tehran',
          city: 'Tehran',
          state: 'Tehran Province',
          country: 'Iran',
          coordinates: {
            lat: 35.8,
            lng: 51.4
          }
        },
        features: ['Private Pool', 'Garden', 'Modern Kitchen', 'Security System'],
        amenities: ['WiFi', 'Air Conditioning', 'Parking', 'BBQ'],
        images: [
          'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
          'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80'
        ],
        mainImage: 'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
        bedrooms: 4,
        bathrooms: 3,
        area: 350,
        yearBuilt: 2020
      },
      {
        title: 'Modern Apartment in Isfahan',
        titleFa: 'آپارتمان مدرن در اصفهان',
        summary: 'Stylish apartment near historic attractions',
        summaryFa: 'آپارتمان شیک نزدیک جاذبه‌های تاریخی',
        description: 'Contemporary living space with a perfect blend of modern comfort and traditional Persian charm.',
        descriptionFa: 'فضای زندگی معاصر با ترکیبی کامل از راحتی مدرن و جذابیت سنتی ایرانی.',
        price: 1800000,
        propertyType: 'apartment',
        status: 'available',
        location: {
          address: 'Chaharbagh Boulevard',
          city: 'Isfahan',
          state: 'Isfahan Province',
          country: 'Iran',
          coordinates: {
            lat: 32.6539,
            lng: 51.6660
          }
        },
        features: ['City View', 'Balcony', 'Modern Appliances'],
        amenities: ['WiFi', 'Air Conditioning', 'Elevator', 'Gym'],
        images: [
          'https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
          'https://images.unsplash.com/photo-1600607687644-c7171b42498b?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80'
        ],
        mainImage: 'https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
        bedrooms: 2,
        bathrooms: 2,
        area: 120,
        yearBuilt: 2019
      },
      {
        title: 'Traditional House in Kashan',
        titleFa: 'خانه سنتی در کاشان',
        summary: 'Historic house with authentic Persian architecture',
        summaryFa: 'خانه تاریخی با معماری اصیل ایرانی',
        description: 'Experience the beauty of traditional Iranian architecture in this restored historic house.',
        descriptionFa: 'تجربه زیبایی معماری سنتی ایرانی در این خانه تاریخی بازسازی شده.',
        price: 1500000,
        propertyType: 'traditional',
        status: 'available',
        location: {
          address: 'Historic District',
          city: 'Kashan',
          state: 'Isfahan Province',
          country: 'Iran',
          coordinates: {
            lat: 33.9850,
            lng: 51.4100
          }
        },
        features: ['Courtyard', 'Traditional Architecture', 'Garden'],
        amenities: ['WiFi', 'Air Conditioning', 'Traditional Kitchen'],
        images: [
          'https://images.unsplash.com/photo-1600585154526-990dced4db0d?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
          'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80'
        ],
        mainImage: 'https://images.unsplash.com/photo-1600585154526-990dced4db0d?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
        bedrooms: 3,
        bathrooms: 2,
        area: 200,
        yearBuilt: 1890
      }
    ];

    // Insert test properties
    await Property.insertMany(testProperties);
    console.log('Test properties created successfully');

    return NextResponse.json({ message: 'Database seeded successfully' });
  } catch (error) {
    console.error('Error in seed route:', error);
    return NextResponse.json(
      { error: error instanceof Error ? error.message : 'Failed to seed database' },
      { status: 500 }
    );
  }
} 