<?php

namespace App\Http\Controllers\Admin;

use App\Http\Requests\HomeRequest;
use Backpack\CRUD\app\Http\Controllers\CrudController;
use Backpack\CRUD\app\Library\CrudPanel\CrudPanelFacade as CRUD;

/**
 * Class HomeCrudController
 * @package App\Http\Controllers\Admin
 * @property-read CrudPanel $crud
 */
class HomeCrudController extends CrudController
{
    use \Backpack\CRUD\app\Http\Controllers\Operations\ListOperation;
    use \Backpack\CRUD\app\Http\Controllers\Operations\CreateOperation;
    use \Backpack\CRUD\app\Http\Controllers\Operations\UpdateOperation;
    use \Backpack\CRUD\app\Http\Controllers\Operations\DeleteOperation;
    use \Backpack\CRUD\app\Http\Controllers\Operations\ShowOperation;

    public function setup()
    {
        $this->crud->setModel('App\Models\Home');
        $this->crud->setRoute(config('backpack.base.route_prefix') . '/home');
        $this->crud->setEntityNameStrings('home', 'home Page');
    }

    protected function setupListOperation()
    {
        // TODO: remove setFromDb() and manually define Columns, maybe Filters
        $this->crud->addColumns([
            [
                'name' => 'card_title',
                'label' => 'Card-Title',
                'type' => 'text',
                'limit' => 100,
            ],
            [
                'name' => 'card_body',
                'label' => 'Card-Body',
                'type' => 'text',
            ],
        ]);

    }

    protected function setupCreateOperation()
    {
        $this->crud->setValidation(HomeRequest::class);

        // TODO: remove setFromDb() and manually define Fields
        $this->crud->addFields([
            [
                'name' => 'card_title',
                'label' => 'Card-Title',
                'type' => 'text',
                'limit' => 100,
            ],
            [
                'name' => 'card_body',
                'label' => 'Card-Body',
                'type' => 'text',
            ],
        ]);
    }

    protected function setupUpdateOperation()
    {
        $this->setupCreateOperation();
    }
}
