<?php

namespace App\Http\Controllers\Admin;

use App\Http\Requests\ScriptRequest;
use App\Models\Dataset;
use App\Models\Indicator;
use App\User;
use Backpack\CRUD\app\Http\Controllers\CrudController;
use Backpack\CRUD\app\Library\CrudPanel\CrudPanelFacade as CRUD;

/**
 * Class ScriptCrudController
 * @package App\Http\Controllers\Admin
 * @property-read \Backpack\CRUD\app\Library\CrudPanel\CrudPanel $crud
 */
class ScriptCrudController extends CrudController
{
    // use HasFileUploads;
    
    use \Backpack\CRUD\app\Http\Controllers\Operations\ListOperation;
    use \Backpack\CRUD\app\Http\Controllers\Operations\CreateOperation { store as traitStore; }
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
        #$this->crud->setFromDb();
        $this->crud->addColumns([
            [
                'name' => 'title',
                'label' => 'Title',
                'type' => 'text'
            ],
            [
                'name' => 'author_id',
                'label' => 'Author',
                'type' => 'select',
                'entity' => 'users',
                'attribute' => 'name',
                'model' => User::class
            ],
            [
                'name' => 'location',
                'label' => 'Geography Region location ',
                'type' => 'text',
            ],
            [
                'name' => 'indicators',
                'key' => 'indicator',
                'label' => 'Dataset-Country-SDG-Group-Subgroup',
                'type' => 'select_multiple',
                'entity' => 'indicators',
                'attribute' => 'combined_label',
                'model' => Indicator::class,
            ],
            [
                'name' => 'indicators',
                'key' => 'sdg_indicator',
                'label' => 'SDG Indicators Calculated',
                'type' => 'select_multiple',
                'entity' => 'indicators',
                'attribute' => 'sdg_indicator_id',
                'model' => Indicator::class,
            ],
            [
                'name' => 'description',
                'label' => 'Description',
                'type' => 'text',
            ],
            [
                'name' => 'script_file',
                'label' => 'Scripts',
                'type' => 'text'
            ],



        ]);
    }

    protected function setupCreateOperation()
    {
        $this->crud->setValidation(ScriptRequest::class);

        $this->crud->addFields([

            [
                'name' => 'title',
                'label' => 'Script Title',
                'type' => 'text',
            ],
            [
                'name' => 'author_id',
                'label' => 'Select the author of the script',
                'type' => 'select2',
                'entity' => 'users',
                'attribute' => 'name',
                'model' => User::class
            ],

            // Datasets (for filtering indicators - not to be saved)
            [
                'name' => 'location',
                'label' => 'Location',
                'type' => 'text',
            ],
            [
                'name' => 'dataset_fake',
                'label' => 'Select the Datasets this script works with',
                'type' => 'select2_multiple',
                'entity' => 'dataset',
                'model' => Dataset::class,
                'attribute' => "description", // foreign key attribute that is shown to user
            ],


            // Indicators
            [
                'name' => 'indicators',
                'label' => 'Select Indicators that are calculated by the script',
                'type' => 'select2_from_ajax_multiple',
                'entity' => 'indicators',
                'attribute' => 'combined_label',
                'model' => Indicator::class,
                'data_source' => url("api/indicators"), // url to controller search function (with /{id} should return model)
                'placeholder' => 'select indicator',
                'minimum_input_length' => 0,
                'pivot' => true,
            ],
            [
                'name' => 'script_file',
                'type' => 'upload_multiple',
                'label' => 'Upload the R script.',
                'upload' => true,
            ],
            [
                'name' => 'description',
                'label' => 'Insert a description',
                'type' => 'tinymce',
            ],

        ]);

    }

    protected function setupUpdateOperation()
    {
        $this->setupCreateOperation();
    }

    public function store()
    {
      // do something before validation, before save, before everything
        $this->request->request->remove('dataset_fake');
        $response = $this->traitStore();

      // do something after save
      return $response;
    }
}
