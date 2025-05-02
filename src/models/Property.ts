import mongoose, { Schema, Document } from 'mongoose';

export interface IProperty extends Document {
  title: string;
  titleFa: string;
  summary: string;
  summaryFa: string;
  description: string;
  descriptionFa: string;
  price: number;
  propertyType: string;
  status: string;
  location: {
    address: string;
    city: string;
    state: string;
    country: string;
    coordinates: {
      lat: number;
      lng: number;
    };
  };
  features: string[];
  amenities: string[];
  images: string[];
  mainImage: string;
  bedrooms: number;
  bathrooms: number;
  area: number;
  yearBuilt: number;
  createdAt: Date;
  updatedAt: Date;
}

const PropertySchema = new Schema<IProperty>({
  title: { type: String, required: true, index: true },
  titleFa: { type: String, required: true },
  summary: { type: String, required: true },
  summaryFa: { type: String, required: true },
  description: { type: String, required: true },
  descriptionFa: { type: String, required: true },
  price: { type: Number, required: true, index: true },
  propertyType: { type: String, required: true, index: true },
  status: { type: String, required: true, default: 'available' },
  location: {
    address: { type: String, required: true },
    city: { type: String, required: true, index: true },
    state: { type: String, required: true },
    country: { type: String, required: true },
    coordinates: {
      lat: { type: Number, required: true },
      lng: { type: Number, required: true }
    }
  },
  features: [{ type: String }],
  amenities: [{ type: String }],
  images: [{ type: String }],
  mainImage: { type: String, required: true },
  bedrooms: { type: Number, required: true },
  bathrooms: { type: Number, required: true },
  area: { type: Number, required: true },
  yearBuilt: { type: Number },
}, {
  timestamps: true,
});

// Create compound indexes for common queries
PropertySchema.index({ price: 1, city: 1 });
PropertySchema.index({ propertyType: 1, price: 1 });
PropertySchema.index({ 'location.city': 1, propertyType: 1 });

// Add text index for search
PropertySchema.index({ title: 'text', titleFa: 'text', description: 'text', descriptionFa: 'text' });

export default mongoose.models.Property || mongoose.model<IProperty>('Property', PropertySchema); 