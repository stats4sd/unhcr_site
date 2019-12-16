<?php

namespace App\Http\Controllers\Admin;

use App\Http\Requests\IndicatorRequest;
use App\Models\Dataset;
use App\Models\Group;
use App\Models\SdgIndicator;
use Backpack\CRUD\app\Http\Controllers\CrudController;
use Backpack\CRUD\app\Library\CrudPanel\CrudPanelFacade as CRUD;

/**
 * Class IndicatorCrudController
 * @package App\Http\Controllers\Admin
 * @property-read CrudPanel $crud
 */
class IndicatorCrudController extends CrudController
{
    use \Backpack\CRUD\app\Http\Controllers\Operations\ListOperation;
    use \Backpack\CRUD\app\Http\Controllers\Operations\CreateOperation;
    use \Backpack\CRUD\app\Http\Controllers\Operations\UpdateOperation;
    use \Backpack\CRUD\app\Http\Controllers\Operations\DeleteOperation;
    use \Backpack\CRUD\app\Http\Controllers\Operations\ShowOperation;

    public function setup()
    {
        $this->crud->setModel('App\Models\Indicator');
        $this->crud->setRoute(config('backpack.base.route_prefix') . '/indicator');
        $this->crud->setEntityNameStrings('indicator', 'indicators');
    }

    protected function setupListOperation()
    {
        // TODO: remove setFromDb() and manually define Columns, maybe Filters

         $this->crud->addColumns([
            [
                'name' => 'dataset_id',
                'label' => 'Dataset',
                'type' => 'select',
                'entity' => 'datasets',
                'attribute' => 'description',
                'model' => Dataset::class
            ],
            [
                'name' => 'group_name',
                'label' => 'Group name',
                'type' => 'text',
            ],
            [
                'name' => 'sdg_indicator_id',
                'label' => 'Sdg Indicator',
                'type' => 'select',
                'entity' => 'sdg_indicator',
                'attribute' => 'full_lable',
                'model' => SdgIndicator::class
            ],
            [
                'name' => 'indicator_value',
                'label' => 'Indicator Value',
                'type' => 'number',
                'decimals' => 5,
            ],
            [
                'name' => 'fake',
                'type' => 'check',
                'label' => 'Fake',
            ],
            [
                'name' => 'created_at',
                'label' => 'Created at',
                'type' => 'datetime',
            ],
            [
                'name' => 'updated_at',
                'label' => 'Updated at',
                'type' => 'datetime',
            ]

        ]);
    }

    protected function setupCreateOperation()
    {
        $this->crud->setValidation(IndicatorRequest::class);

        // TODO: remove setFromDb() and manually define Fields

        //$this->crud->setFromDb();
        $this->crud->addFields([
            [
                'type' => 'custom_html',
                'name' => 'main_title',
                'value' => '<h4>Insert the following fields</h4>'
            ],
            [
                'name' => 'dataset_id',
                'label' => 'Dataset',
                'type' => 'select2',
                'entity' => 'datasets',
                'attribute' => 'description',
                'model' => Dataset::class
            ],
            [
                'name' => 'group_name',
                'label' => 'Group name',
                'type' => 'select2',
                'entity' => 'groups',
                'attribute' => 'name',
                'model' => Group::class
            ],
            [
                'name' => 'sdg_indicator_id',
                'label' => 'Sdg Indicator',
                'type' => 'select2',
                'entity' => 'sdg_indicator',
                'attribute' => 'full_lable',
                'model' => SdgIndicator::class
            ],
            [
                'name' => 'indicator_value',
                'label' => 'Indicator Value',
                'attributes' => [
                    'step' => 'any',
                ],
                'type' => 'number',
            ],
            [
                'name' => 'fake',
                'type' => 'checkbox',
                'label' => 'Is it fake?',
            ],

        ]);
    }

    protected function setupUpdateOperation()
    {
        $this->setupCreateOperation();
    }
}
