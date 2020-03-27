<?php

namespace App\Http\Controllers\Admin;

use App\Http\Requests\ScriptRequest;
use Backpack\CRUD\app\Http\Controllers\CrudController;
use Backpack\CRUD\app\Library\CrudPanel\CrudPanelFacade as CRUD;

/**
 * Class ScriptCrudController
 * @package App\Http\Controllers\Admin
 * @property-read \Backpack\CRUD\app\Library\CrudPanel\CrudPanel $crud
 */
class ScriptCrudController extends CrudController
{
    use \Backpack\CRUD\app\Http\Controllers\Operations\ListOperation;
    use \Backpack\CRUD\app\Http\Controllers\Operations\CreateOperation;
    use \Backpack\CRUD\app\Http\Controllers\Operations\UpdateOperation;
    use \Backpack\CRUD\app\Http\Controllers\Operations\DeleteOperation;
    use \Backpack\CRUD\app\Http\Controllers\Operations\ShowOperation;

    public function setup()
    {
        $this->crud->setModel('App\Models\Script');
        $this->crud->setRoute(config('backpack.base.route_prefix') . '/script');
        $this->crud->setEntityNameStrings('script', 'scripts');
    }

    protected function setupListOperation()
    {
        // TODO: remove setFromDb() and manually define Columns, maybe Filters
        $this->crud->setFromDb();
        $this->crud->addColumns([
            [
                'name' => 'user_id',
                'label' => 'Author',
                'type' => 'select',
                'entity' => 'users',
                'attribute' => 'name',
                'model' => User::class
            ],

        ]);
    }

    protected function setupCreateOperation()
    {
        $this->crud->setValidation(ScriptRequest::class);

        $this->crud->addFields([
           
            [
                'name' => 'user_id',
                'label' => 'Select the author of the script',
                'type' => 'select2',
                'entity' => 'users',
                'attribute' => 'name',
                'model' => User::class
            ]
        ]);

    }

    protected function setupUpdateOperation()
    {
        $this->setupCreateOperation();
    }
}
