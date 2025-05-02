import { Logo } from '@/components/shared/Logo';

export default function LogoDemo() {
  return (
    <div className="min-h-screen bg-gray-100 p-8">
      <div className="max-w-3xl mx-auto space-y-8">
        <h1 className="text-2xl font-bold text-gray-900">Logo Showcase</h1>
        
        {/* Light variants */}
        <div className="space-y-4">
          <h2 className="text-lg font-semibold text-gray-700">Light Version</h2>
          <div className="space-y-4 bg-white p-8 rounded-xl shadow-lg">
            <div>
              <p className="text-sm text-gray-500 mb-2">Small</p>
              <Logo size="sm" />
            </div>
            <div>
              <p className="text-sm text-gray-500 mb-2">Medium (Default)</p>
              <Logo size="md" />
            </div>
            <div>
              <p className="text-sm text-gray-500 mb-2">Large</p>
              <Logo size="lg" />
            </div>
          </div>
        </div>

        {/* Dark variants */}
        <div className="space-y-4">
          <h2 className="text-lg font-semibold text-gray-700">Dark Version</h2>
          <div className="space-y-4 bg-gray-900 p-8 rounded-xl shadow-lg">
            <div>
              <p className="text-sm text-gray-400 mb-2">Small</p>
              <Logo size="sm" variant="dark" />
            </div>
            <div>
              <p className="text-sm text-gray-400 mb-2">Medium (Default)</p>
              <Logo size="md" variant="dark" />
            </div>
            <div>
              <p className="text-sm text-gray-400 mb-2">Large</p>
              <Logo size="lg" variant="dark" />
            </div>
          </div>
        </div>
      </div>
    </div>
  );
} 