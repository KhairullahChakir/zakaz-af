<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     * Enhances addresses table for recipient/diaspora model
     */
    public function up(): void
    {
        Schema::table('addresses', function (Blueprint $table) {
            // Recipient Information
            $table->string('recipient_name')->nullable()->after('label');
            $table->string('phone_primary')->nullable()->after('recipient_name');
            $table->string('phone_secondary')->nullable()->after('phone_primary');
            
            // Enhanced Location
            $table->string('country')->default('Afghanistan')->after('zip_code');
            $table->string('province')->nullable()->after('country');
            $table->string('district')->nullable()->after('province');
            $table->string('street')->nullable()->after('district');
            $table->string('house_number')->nullable()->after('street');
            $table->string('apartment_number')->nullable()->after('house_number');
            
            // Additional helpful fields
            $table->text('delivery_instructions')->nullable()->after('apartment_number');
            $table->decimal('latitude', 10, 8)->nullable()->after('delivery_instructions');
            $table->decimal('longitude', 11, 8)->nullable()->after('latitude');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('addresses', function (Blueprint $table) {
            $table->dropColumn([
                'recipient_name',
                'phone_primary',
                'phone_secondary',
                'country',
                'province',
                'district',
                'street',
                'house_number',
                'apartment_number',
                'delivery_instructions',
                'latitude',
                'longitude',
            ]);
        });
    }
};
