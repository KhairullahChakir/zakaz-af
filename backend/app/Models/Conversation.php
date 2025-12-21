<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Conversation extends Model
{
    protected $fillable = [
        'customer_id',
        'shop_id',
        'product_id',
        'last_message_at',
    ];

    protected $casts = [
        'last_message_at' => 'datetime',
    ];

    protected $appends = ['unread_count'];

    public function customer(): BelongsTo
    {
        return $this->belongsTo(User::class, 'customer_id');
    }

    public function shop(): BelongsTo
    {
        return $this->belongsTo(Shop::class);
    }

    public function product(): BelongsTo
    {
        return $this->belongsTo(Product::class);
    }

    public function messages(): HasMany
    {
        return $this->hasMany(Message::class)->orderBy('created_at', 'asc');
    }

    public function latestMessage()
    {
        return $this->hasOne(Message::class)->latestOfMany();
    }

    public function getUnreadCountAttribute(): int
    {
        $userId = auth()->id();
        return $this->messages()->where('sender_id', '!=', $userId)->where('is_read', false)->count();
    }

    /**
     * Get the other participant (for the current user)
     */
    public function getOtherParticipant()
    {
        $userId = auth()->id();
        if ($this->customer_id == $userId) {
            return $this->shop?->owner;
        }
        return $this->customer;
    }
}
