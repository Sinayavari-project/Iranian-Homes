import { NextResponse } from 'next/server';
import connectDB from '@/lib/mongodb';
import Property from '@/models/Property';
import mongoose from 'mongoose';

export async function GET(request: Request) {
  console.log('Properties API route called');
  
  try {
    // Ensure database connection is established first
    const db = await connectDB();
    console.log('MongoDB connected in API route');

    // Wait for connection to be ready
    if (db.connection.readyState !== 1) {
      throw new Error('MongoDB connection not ready');
    }

    const { searchParams } = new URL(request.url);
    const query = searchParams.get('query') || '';
    const propertyType = searchParams.get('propertyType') || '';
    const minPrice = searchParams.get('minPrice') || '0';
    const maxPrice = searchParams.get('maxPrice') || '999999999';
    const city = searchParams.get('city') || '';
    const page = parseInt(searchParams.get('page') || '1');
    const limit = parseInt(searchParams.get('limit') || '10');

    console.log('Search params:', { query, propertyType, minPrice, maxPrice, city, page, limit });

    const filter: any = {};

    if (query) {
      filter.$or = [
        { title: { $regex: query, $options: 'i' } },
        { description: { $regex: query, $options: 'i' } },
      ];
    }

    if (propertyType) {
      filter.propertyType = propertyType;
    }

    if (city) {
      filter['location.city'] = city;
    }

    filter.price = {
      $gte: parseInt(minPrice),
      $lte: parseInt(maxPrice),
    };

    console.log('Applying MongoDB filter:', JSON.stringify(filter, null, 2));

    const skip = (page - 1) * limit;

    // Use Promise.all to run queries in parallel
    const [properties, total] = await Promise.all([
      Property.find(filter).skip(skip).limit(limit).lean(),
      Property.countDocuments(filter)
    ]);

    console.log(`Found ${properties.length} properties out of ${total} total`);

    return NextResponse.json({
      properties,
      total,
      page,
      totalPages: Math.ceil(total / limit),
    });
  } catch (error) {
    console.error('Error in GET /api/properties:', error);
    return NextResponse.json(
      { error: error instanceof Error ? error.message : 'Failed to fetch properties' },
      { status: 500 }
    );
  }
} 