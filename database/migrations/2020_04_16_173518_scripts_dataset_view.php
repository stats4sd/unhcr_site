<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class ScriptsDatasetView extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        DB::statement("DROP VIEW IF EXISTS scripts_dataset");
        DB::statement("
            CREATE VIEW scripts_dataset AS
            SELECT 
            
                `link_scripts_indicators`.`script_id` AS `script_id`,
                `link_scripts_indicators`.`indicator_id` AS `indicator_id`,
                `indicators`.`dataset_id` AS `dataset_id`,
                `sdg_indicators`.`code` AS `sdg_code`,
                `indicators`.`group_name` AS `group_name`,
                `indicators`.`subgroup_name` AS `subgroup_name`,
                `datasets`.`description` AS `dataset_description`,
                 `users`.`name` AS `author`

                FROM `link_scripts_indicators` 
                    LEFT JOIN `scripts` ON `scripts`.`id` = `link_scripts_indicators`.`script_id`
                   
                    JOIN `indicators` on`link_scripts_indicators`.`indicator_id` = `indicators`.`id`
                    JOIN `sdg_indicators`on `indicators`.`sdg_indicator_id` = `sdg_indicators`.`id`
                    JOIN `datasets` on `indicators`.`dataset_id` = `datasets`.`id`
                    JOIN `users` on `scripts`.`author_id` = `users`.`id`

               
        ");
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        DB::statement("DROP VIEW IF EXISTS scripts_dataset");
    }
}
