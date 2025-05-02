const https = require('https');
const fs = require('fs');
const path = require('path');

const images = [
  {
    url: 'https://images.unsplash.com/photo-1613490493576-7fde63acd811?w=800&q=80',
    filename: 'dubai1.jpg'
  },
  {
    url: 'https://images.unsplash.com/photo-1613490493576-7fde63acd811?w=800&q=80',
    filename: 'dubai1-2.jpg'
  },
  {
    url: 'https://images.unsplash.com/photo-1613490493576-7fde63acd811?w=800&q=80',
    filename: 'dubai1-3.jpg'
  },
  {
    url: 'https://images.unsplash.com/photo-1613490493576-7fde63acd811?w=800&q=80',
    filename: 'dubai2.jpg'
  },
  {
    url: 'https://images.unsplash.com/photo-1613490493576-7fde63acd811?w=800&q=80',
    filename: 'dubai2-2.jpg'
  },
  {
    url: 'https://images.unsplash.com/photo-1613490493576-7fde63acd811?w=800&q=80',
    filename: 'dubai2-3.jpg'
  },
  {
    url: 'https://images.unsplash.com/photo-1613490493576-7fde63acd811?w=800&q=80',
    filename: 'dubai3.jpg'
  },
  {
    url: 'https://images.unsplash.com/photo-1613490493576-7fde63acd811?w=800&q=80',
    filename: 'dubai3-2.jpg'
  },
  {
    url: 'https://images.unsplash.com/photo-1613490493576-7fde63acd811?w=800&q=80',
    filename: 'dubai3-3.jpg'
  },
  {
    url: 'https://images.unsplash.com/photo-1613490493576-7fde63acd811?w=800&q=80',
    filename: 'dubai4.jpg'
  },
  {
    url: 'https://images.unsplash.com/photo-1613490493576-7fde63acd811?w=800&q=80',
    filename: 'dubai4-2.jpg'
  },
  {
    url: 'https://images.unsplash.com/photo-1613490493576-7fde63acd811?w=800&q=80',
    filename: 'dubai4-3.jpg'
  },
  {
    url: 'https://images.unsplash.com/photo-1613490493576-7fde63acd811?w=800&q=80',
    filename: 'dubai5.jpg'
  },
  {
    url: 'https://images.unsplash.com/photo-1613490493576-7fde63acd811?w=800&q=80',
    filename: 'dubai5-2.jpg'
  },
  {
    url: 'https://images.unsplash.com/photo-1613490493576-7fde63acd811?w=800&q=80',
    filename: 'dubai5-3.jpg'
  }
];

const outputDir = path.join(__dirname, '../public/images/properties');

// Create directory if it doesn't exist
if (!fs.existsSync(outputDir)) {
  fs.mkdirSync(outputDir, { recursive: true });
}

// Download each image
images.forEach(({ url, filename }) => {
  const filePath = path.join(outputDir, filename);
  const file = fs.createWriteStream(filePath);

  https.get(url, (response) => {
    response.pipe(file);

    file.on('finish', () => {
      file.close();
      console.log(`Downloaded ${filename}`);
    });
  }).on('error', (err) => {
    fs.unlink(filePath, () => {});
    console.error(`Error downloading ${filename}: ${err.message}`);
  });
}); 