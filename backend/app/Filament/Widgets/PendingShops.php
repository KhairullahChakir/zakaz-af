<?php

namespace App\Filament\Widgets;

use App\Models\Shop;
use Filament\Tables;
use Filament\Tables\Table;
use Filament\Widgets\TableWidget as BaseWidget;
use Filament\Actions\Action;

class PendingShops extends BaseWidget
{
    protected static ?int $sort = 3;

    protected int|string|array $columnSpan = 'full';

    public function table(Table $table): Table
    {
        return $table
            ->query(
                fn() => Shop::query()
                    ->where('status', 'pending')
                    ->with(['owner'])
                    ->orderBy('created_at', 'desc')
            )
            ->columns([
                Tables\Columns\ImageColumn::make('primary_photo_url')
                    ->label('Photo')
                    ->circular(),
                Tables\Columns\TextColumn::make('name')
                    ->searchable(),
                Tables\Columns\TextColumn::make('owner.name')
                    ->label('Owner'),
                Tables\Columns\TextColumn::make('type')
                    ->badge(),
                Tables\Columns\TextColumn::make('city'),
                Tables\Columns\TextColumn::make('created_at')
                    ->label('Applied')
                    ->since(),
            ])
            ->actions([
                Action::make('review')
                    ->url(fn(Shop $record): string => '/admin/shops/' . $record->id)
                    ->icon('heroicon-o-eye')
                    ->color('warning'),
            ])
            ->heading('Pending Shop Applications')
            ->emptyStateHeading('No pending applications')
            ->emptyStateDescription('All shop applications have been reviewed.')
            ->emptyStateIcon('heroicon-o-check-circle');
    }
}
