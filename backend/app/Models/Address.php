<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Address extends Model
{
    protected $fillable = [
        'user_id',
        'label',
        // Recipient Information
        'recipient_name',
        'phone_primary',
        'phone_secondary',
        // Original fields
        'address_line_1',
        'address_line_2',
        'city',
        'state',
        'zip_code',
        // Enhanced Location
        'country',
        'province',
        'district',
        'street',
        'house_number',
        'apartment_number',
        // Additional
        'delivery_instructions',
        'latitude',
        'longitude',
        'is_default',
    ];

    protected $casts = [
        'is_default' => 'boolean',
        'user_id' => 'integer',
        'latitude' => 'decimal:8',
        'longitude' => 'decimal:8',
    ];

    /**
     * Get formatted full address
     */
    public function getFullAddressAttribute(): string
    {
        $parts = array_filter([
            $this->house_number ? "House {$this->house_number}" : null,
            $this->apartment_number ? "Apt {$this->apartment_number}" : null,
            $this->street,
            $this->district,
            $this->city,
            $this->province,
            $this->country,
        ]);
        
        return implode(', ', $parts);
    }

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
