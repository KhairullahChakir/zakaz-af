<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Address;
use Illuminate\Http\Request;

class AddressController extends Controller
{
    /**
     * Common validation rules for address fields
     */
    private function getValidationRules(): array
    {
        return [
            // Label & Recipient
            'label' => 'required|string|max:50',
            'recipient_name' => 'required|string|max:100',
            'phone_primary' => 'required|string|max:20',
            'phone_secondary' => 'nullable|string|max:20',
            
            // Legacy fields (keeping for backward compatibility)
            'address_line_1' => 'nullable|string|max:255',
            'address_line_2' => 'nullable|string|max:255',
            
            // Location
            'country' => 'required|string|max:100',
            'province' => 'required|string|max:100',
            'city' => 'required|string|max:100',
            'district' => 'nullable|string|max:100',
            'street' => 'nullable|string|max:255',
            'house_number' => 'nullable|string|max:20',
            'apartment_number' => 'nullable|string|max:20',
            'state' => 'nullable|string|max:100',
            'zip_code' => 'nullable|string|max:20',
            
            // Additional
            'delivery_instructions' => 'nullable|string|max:500',
            'latitude' => 'nullable|numeric|between:-90,90',
            'longitude' => 'nullable|numeric|between:-180,180',
            'is_default' => 'boolean',
        ];
    }

    public function index(Request $request)
    {
        $addresses = $request->user()->addresses()
            ->orderBy('is_default', 'desc')
            ->orderBy('updated_at', 'desc')
            ->get();
            
        return response()->json($addresses);
    }

    public function store(Request $request)
    {
        $validated = $request->validate($this->getValidationRules());

        // If setting as default, unset other defaults
        if ($request->boolean('is_default')) {
            $request->user()->addresses()->update(['is_default' => false]);
        }

        // Build address_line_1 from components if not provided
        if (empty($validated['address_line_1'])) {
            $validated['address_line_1'] = $this->buildAddressLine($validated);
        }

        $address = $request->user()->addresses()->create($validated);

        return response()->json($address, 201);
    }

    public function update(Request $request, $id)
    {
        $address = $request->user()->addresses()->findOrFail($id);

        $validated = $request->validate($this->getValidationRules());

        // If setting as default, unset other defaults
        if ($request->boolean('is_default')) {
            $request->user()->addresses()->where('id', '!=', $id)->update(['is_default' => false]);
        }

        // Build address_line_1 from components if not provided
        if (empty($validated['address_line_1'])) {
            $validated['address_line_1'] = $this->buildAddressLine($validated);
        }

        $address->update($validated);

        return response()->json($address);
    }

    public function destroy(Request $request, $id)
    {
        $address = $request->user()->addresses()->findOrFail($id);
        $address->delete();

        return response()->json(['message' => 'Address deleted successfully']);
    }

    /**
     * Build address line from individual components
     */
    private function buildAddressLine(array $data): string
    {
        $parts = array_filter([
            $data['house_number'] ?? null ? "House {$data['house_number']}" : null,
            $data['apartment_number'] ?? null ? "Apt {$data['apartment_number']}" : null,
            $data['street'] ?? null,
            $data['district'] ?? null,
        ]);
        
        return implode(', ', $parts) ?: 'N/A';
    }
}
