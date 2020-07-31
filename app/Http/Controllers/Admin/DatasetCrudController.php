<?php

namespace App\Http\Controllers\Admin;

use App\Http\Requests\DatasetRequest;
use App\Models\Country;
use App\Models\Script;
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
                'label' => 'Country',
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
                'name' => 'fake',
                'type' => 'check',
                'label' => 'Fake',
            ],
            [
                'name' => 'comment',
                'type' => 'text',
                'label' => 'Comments',
                'limit' => 100,
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
                'label' => 'Select the country where the data was collected',
                'type' => 'select2',
                'entity' => 'countries',
                'attribute' => 'name',
                'model' => Country::class
            ],
            [
                'name' => 'region',
                'label' => 'Add the specific region:',
                'hint' => 'Leave blank if unknown or if the dataset is country-wide',
                'type' => 'text',
            ],
            [   // date_picker
               'name' => 'year',
               'type' => 'number',
               'label' => 'What year was the data collected?',
            ],
            [
                'name' => 'description',
                'type' => 'text',
                'label' => 'Enter a descriptive title for the dataset',
                'hint' => 'This will be used to recognise this dataset in other parts of the platform',
            ],
            [
                'name' => 'population_definition',
                'type' => 'text',
                'label' => 'Give the definition of the population for which the dataset applies',
            ],
            [
                'name' => 'source_url',
                'type' => 'url',
                'label' => 'If the dataset is available online, enter the url where the source data can be found',
            ],
            [
                'name' => 'fake',
                'type' => 'checkbox',
                'label' => 'Is this a fake dataset?',
                'hint' => 'Fake datasets are used to test the system. No fake data should be present in the live platform',
            ],
            [
                'name' => 'comment',
                'type' => 'tinymce',
                'label' => 'Add any comments about this specific dataset:',
                'options' => [
                    'selector' => 'textarea.tinymce',
                    'plugins' => 'image,link,media,anchor,textcolor,colorpicker',
                    'toolbar' => [
                        'undo redo | styleselect | bold italic | link image | forecolor',
                        'alignleft aligncenter alignright'
                    ],
                ]
            ]
        ]);
    }

    protected function setupUpdateOperation()
    {
        $this->setupCreateOperation();
    }
}
