<?php

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

Route::get('/', function(){

    return redirect('home');

});

Route::get('home', 'HomeController@index');

Route::get('lessons', 'LessonController@index');
Route::get('lesson_page', function(){
	return view('lesson_page');
});
Route::get('/lessons/{slug}', 'LessonPageController@index');

Route::get('available-data', function() {
    return view('available-data');
});

Route::get('sdgs', function() {
    return view('sdgs');
});

/**
 * Endpoints for custom filters in Backpack Crud Panels
 */
Route::get('api/indicators', 'IndicatorsFilterController@index');
Route::get('api/indicators/{id}', 'IndicatorsFilterController@show');


