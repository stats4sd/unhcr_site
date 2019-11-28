<?php

namespace App\Http\Controllers\Admin;

use App\Http\Requests\LessonRequest;
use Backpack\CRUD\app\Http\Controllers\CrudController;
use Backpack\CRUD\app\Library\CrudPanel\CrudPanelFacade as CRUD;
use Illuminate\Support\Facades\Request;

/**
 * Class LessonCrudController
 * @package App\Http\Controllers\Admin
 * @property-read CrudPanel $crud
 */
class LessonCrudController extends CrudController
{
    use \Backpack\CRUD\app\Http\Controllers\Operations\ListOperation { store as traitStore; }
    use \Backpack\CRUD\app\Http\Controllers\Operations\CreateOperation;
    use \Backpack\CRUD\app\Http\Controllers\Operations\UpdateOperation;
    use \Backpack\CRUD\app\Http\Controllers\Operations\DeleteOperation;
    use \Backpack\CRUD\app\Http\Controllers\Operations\ShowOperation;

    public function setup()
    {
        $this->crud->setModel('App\Models\Lesson');
        $this->crud->setRoute(config('backpack.base.route_prefix') . '/lesson');
        $this->crud->setEntityNameStrings('lesson', 'lessons');
    }

    protected function setupListOperation()
    {
        // TODO: remove setFromDb() and manually define Columns, maybe Filters
        $this->crud->setFromDb();
    }

    protected function setupCreateOperation()
    {
        $this->crud->setValidation(LessonRequest::class);

        // TODO: remove setFromDb() and manually define Fields
        $this->crud->addFields([
            [
                'type' => 'custom_html',
                'name' => 'main_title',
                'value' => '<h4>Create the lesson Page</h4>'
            ],
            [
                'type' => 'text',
                'name' => 'title',
                'label' => 'Lesson title',
            ],
            [
                'type' => 'text',
                'name' => 'comment',
                'label' => 'Insert a short descrition for the lesson page',
            ],
            [   // TinyMCE
                'name' => 'body_1',
                'label' => 'Body_1',
                'type' => 'tinymce',
                // optional overwrite of the configuration array
                // 'options' => [ 'selector' => 'textarea.tinymce',  'skin' => 'dick-light', 'plugins' => 'image,link,media,anchor' ],
            ],
                       
        ]);
    }

    protected function setupUpdateOperation()
    {
        $this->setupCreateOperation();
    }
}
