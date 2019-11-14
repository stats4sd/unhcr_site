<?php

namespace App\Http\Controllers;

use App\Models\Home;
use Illuminate\Http\Request;

class HomeController extends Controller
{
    public function index()
    {
    	$cards = Home::all();
    	return View('home',compact('cards'));
    }
}
