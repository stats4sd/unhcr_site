<?php

namespace App\Http\Controllers;

use App\Models\Lesson;
use Illuminate\Http\Request;

class LessonPageController extends Controller
{
    public function index($slug)
    {
    	$lesson_page = Lesson::where('slug', $slug)->first();
    	return view('lesson_page', compact('lesson_page'));
    }
}

