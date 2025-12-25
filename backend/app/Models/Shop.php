<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Shop extends Model
{
    protected $fillable = [
        'owner_id',
        'name',
        'type',
        'description',
        'address',
        'city',
        'province',
        'latitude',
        'longitude',
        'photos',
        'business_license',
        'owner_nid',
        'phone',
        'email',
        'status',
        'rejection_reason',
        'approved_at',
    ];

    protected $casts = [
        'photos' => 'array',
        'latitude' => 'double',
        'longitude' => 'double',
        'approved_at' => 'datetime',
    ];

    protected $appends = ['primary_photo_url', 'business_license_url'];

    public function getPrimaryPhotoUrlAttribute()
    {
        if ($this->photos && count($this->photos) > 0) {
            $photo = $this->photos[0];
            if (filter_var($photo, FILTER_VALIDATE_URL)) {
                return $photo;
            }
            return asset('storage/' . $photo);
        }
        return null;
    }

    public function getBusinessLicenseUrlAttribute()
    {
        if ($this->business_license) {
            return asset('storage/' . $this->business_license);
        }
        return null;
    }

    public function owner()
    {
        return $this->belongsTo(User::class, 'owner_id');
    }

    public function products()
    {
        return $this->hasMany(Product::class);
    }

    public function isPending()
    {
        return $this->status === 'pending';
    }

    public function isApproved()
    {
        return $this->status === 'approved';
    }

    public function isRejected()
    {
        return $this->status === 'rejected';
    }

    public function isSuspended()
    {
        return $this->status === 'suspended';
    }
}
