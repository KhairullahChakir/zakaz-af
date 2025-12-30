<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::table('conversations', function (Blueprint $table) {
            if (!Schema::hasColumn('conversations', 'marketplace_item_id')) {
                $table->foreignId('marketplace_item_id')->nullable()->after('product_id')->constrained('marketplace_items')->onDelete('cascade');
            }
            if (!Schema::hasColumn('conversations', 'seller_id')) {
                $table->foreignId('seller_id')->nullable()->after('customer_id')->constrained('users')->onDelete('cascade');
            }
            
            // Re-check shop_id nullability
            $table->foreignId('shop_id')->nullable()->change();
        });

        // Drop unique constraint if it exists
        try {
            Schema::table('conversations', function (Blueprint $table) {
                $table->dropUnique(['customer_id', 'shop_id']);
            });
        } catch (\Exception $e) {
            // Already dropped or different name
        }

        Schema::table('conversations', function (Blueprint $table) {
            // Add non-unique indices
            $table->index(['customer_id', 'shop_id'], 'conversations_cus_shop_idx');
            $table->index(['customer_id', 'seller_id'], 'conversations_cus_sel_idx');
        });
    }

    public function down(): void
    {
        Schema::table('conversations', function (Blueprint $table) {
            $table->unique(['customer_id', 'shop_id']);
            $table->foreignId('shop_id')->nullable(false)->change();
            
            $table->dropIndex('conversations_cus_shop_idx');
            $table->dropIndex('conversations_cus_sel_idx');
            
            $table->dropForeign(['marketplace_item_id']);
            $table->dropForeign(['seller_id']);
            $table->dropColumn(['marketplace_item_id', 'seller_id']);
        });
    }
};
