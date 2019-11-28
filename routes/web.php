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
	View('lesson_page');
});
Route::get('/lessons/{slug}', 'LessonPageController@index');