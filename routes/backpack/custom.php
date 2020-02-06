<?php

// --------------------------
// Custom Backpack Routes
// --------------------------
// This route file is loaded automatically by Backpack\Base.
// Routes you generate using Backpack\Generators will be placed here.

Route::group([
    'prefix'     => config('backpack.base.route_prefix', 'admin'),
    'middleware' => ['web', config('backpack.base.middleware_key', 'admin')],
    'namespace'  => 'App\Http\Controllers\Admin',
], function () { // custom admin routes
    Route::crud('home', 'HomeCrudController');
    Route::crud('lesson', 'LessonCrudController');
    Route::crud('indicator', 'IndicatorCrudController');
    Route::crud('dataset', 'DatasetCrudController');
    Route::crud('comment', 'CommentCrudController');
    Route::crud('sdgindicator', 'SdgIndicatorCrudController');
    Route::crud('group', 'GroupCrudController');
    // Route::crud('country', 'CountryCrudController');
    Route::crud('homepagecard', 'HomePageCardCrudController');
    Route::crud('subgroup', 'SubgroupCrudController');
}); // this should be the absolute last line of this file