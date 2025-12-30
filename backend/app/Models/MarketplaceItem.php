<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class MarketplaceItem extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'category_id',
        'name',
        'description',
        'price',
        'condition',
        'phone',
        'location',
        'status',
    ];

    protected $casts = [
        'price' => 'double',
        'user_id' => 'integer',
        'category_id' => 'integer',
    ];

    protected $appends = ['main_image_url', 'gallery_urls'];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function category()
    {
        return $this->belongsTo(Category::class);
    }

    public function images()
    {
        return $this->hasMany(MarketplaceItemImage::class);
    }

    public function getMainImageUrlAttribute()
    {
        $firstImage = $this->images()->first();
        if ($firstImage) {
            return asset('storage/' . $firstImage->image_path);
        }
        return null;
    }

    public function getGalleryUrlsAttribute()
    {
        return $this->images->map(function($img) {
            return asset('storage/' . $img->image_path);
        });
    }
}
