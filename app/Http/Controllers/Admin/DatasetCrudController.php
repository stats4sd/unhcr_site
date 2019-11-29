<?php

namespace App\Http\Controllers\Admin;

use App\Http\Requests\DatasetRequest;
use App\Models\Country;
use Backpack\CRUD\app\Http\Controllers\CrudController;
use Backpack\CRUD\app\Library\CrudPanel\CrudPanelFacade as CRUD;

/**
 * Class DatasetCrudController
 * @package App\Http\Controllers\Admin
 * @property-read CrudPanel $crud
 */
class DatasetCrudController extends CrudController
{
    use \Backpack\CRUD\app\Http\Controllers\Operations\ListOperation;
    use \Backpack\CRUD\app\Http\Controllers\Operations\CreateOperation;
    use \Backpack\CRUD\app\Http\Controllers\Operations\UpdateOperation;
    use \Backpack\CRUD\app\Http\Controllers\Operations\DeleteOperation;
    use \Backpack\CRUD\app\Http\Controllers\Operations\ShowOperation;

    public function setup()
    {
        $this->crud->setModel('App\Models\Dataset');
        $this->crud->setRoute(config('backpack.base.route_prefix') . '/dataset');
        $this->crud->setEntityNameStrings('dataset', 'datasets');
    }

    protected function setupListOperation()
    {
        // TODO: remove setFromDb() and manually define Columns, maybe Filters
        $this->crud->addColumns([
            
            [
                'name' => 'country_code',
                'label' => 'ISO code',
                'type' => 'select',
                'entity' => 'countries',
                'attribute' => 'name',
                'model' => Country::class
            ],
            [
                'name' => 'region',
                'label' => 'Region',
                'type' => 'text',    
            ],
            [   // date_picker
               'name' => 'year',
               'type' => 'number',
               'label' => 'Year',
            ],
            [
                'name' => 'description',
                'type' => 'text',
                'label' => 'Description',
            ],
            [
                'name' => 'population_definition',
                'type' => 'text',
                'label' => 'Population definition',
            ],
            [
                'name' => 'source_url',
                'type' => 'url',
                'label' => 'Source url',
            ],
            [
                'name' => 'scripts_url',
                'type' => 'url',
                'label' => 'Scripts url',
            ],
            [
                'name' => 'fake',
                'type' => 'check',
                'label' => 'Fake',
            ],
            [
                'name' => 'created_at',
                'type' => 'datetime',
                'label' => 'Created at',
            ],
            [
                'name' => 'updated_at',
                'type' => 'datetime',
                'label' => 'Updated at',
            ]

        ]);
    }

    protected function setupCreateOperation()
    {
        $this->crud->setValidation(DatasetRequest::class);

        // TODO: remove setFromDb() and manually define Fields
        $this->crud->addFields([
            [
                'type' => 'custom_html',
                'name' => 'main_title',
                'value' => '<h4>Insert the following fields</h4>'
            ],
            [
                'name' => 'country_code',
                'label' => 'ISO code',
                'type' => 'select2',
                'entity' => 'countries',
                'attribute' => 'name',
                'model' => Country::class
            ],
            [
                'name' => 'region',
                'label' => 'Region',
                'type' => 'text',    
            ],
            [   // date_picker
               'name' => 'year',
               'type' => 'number',
               'label' => 'Year',
            ],
            [
                'name' => 'description',
                'type' => 'text',
                'label' => 'Description',
            ],
            [
                'name' => 'population_definition',
                'type' => 'text',
                'label' => 'Population definition',
            ],
            [
                'name' => 'source_url',
                'type' => 'url',
                'label' => 'Source url',
            ],
            [
                'name' => 'scripts_url',
                'type' => 'url',
                'label' => 'Scripts url',
            ],
            [
                'name' => 'fake',
                'type' => 'checkbox',
                'label' => 'Is it fake?',
            ]

        ]);
    }

    protected function setupUpdateOperation()
    {
        $this->setupCreateOperation();
    }
}
