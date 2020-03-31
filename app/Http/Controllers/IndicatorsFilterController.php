<?php

namespace App\Http\Controllers;

use App\Models\Indicator;
use App\Models\Lesson;
use Illuminate\Http\Request;

class IndicatorsFilterController extends Controller
{

    public function index(Request $request)
    {
        // $search_term = $request->input('q');

        $form = collect($request->input('form'));

        // For when dependant field is a multi-select...
        $dataset_ids = $form->map( function($item, $key){
            if($item['name'] == 'dataset_fake[]' || $item['name'] == 'dataset_fake'){
                return $item['value'];
            }

        });

        $options = Indicator::query();


        // if no category has been selected, show no options
        if ( $dataset_ids->count() == 0) {
            return [];
        }


        // if a category has been selected, only show articles in that category
        $options = $options->whereIn('dataset_id', $dataset_ids);

        // if ($search_term) {
        //     $results = $options->where('title', 'LIKE', '%'.$search_term.'%')->paginate(10);
        // } else {
        //     $results = $options->paginate(10);
        // }

        return $options->paginate(10);
    }

    public function show($id)
    {
        return Indicator::find($id);
    }
}


