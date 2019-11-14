<?php

namespace App\Http\Controllers;

use App\User;
use DataTables;
use Illuminate\Http\Request;

class ChartController extends Controller
{
    public function index()
    {
    	$datatable = DataTables::of(User::query())->make(true);
    	return view('charts', compact('datatable'));
    }

    /**
	 * Process datatables ajax request.
	 *
	 * @return \Illuminate\Http\JsonResponse
	 */
	public function anyData()
	{
	    return DataTables::of(User::query())->make(true);
	}
}
