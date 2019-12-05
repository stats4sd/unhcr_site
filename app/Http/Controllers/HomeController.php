<?php

namespace App\Http\Controllers;

use App\Models\HomePageCard;
use Illuminate\Http\Request;

class HomeController extends Controller
{
    public function index()
    {
    	$cards = HomePageCard::all();
    	return View('home',compact('cards'));
    }
}
