<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class MarketplaceItemImage extends Model
{
    use HasFactory;

    protected $fillable = [
        'marketplace_item_id',
        'image_path',
    ];

    protected $appends = ['image_url'];

    public function marketplaceItem()
    {
        return $this->belongsTo(MarketplaceItem::class);
    }

    public function getImageUrlAttribute()
    {
        return asset('storage/' . $this->image_path);
    }
}
