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
                GROUP_CONCAT(`link_scripts_indicators`.`indicator_id` SEPARATOR ', ') AS `indicator_id`,
                `indicators`.`dataset_id` AS `dataset_id`,
                GROUP_CONCAT(DISTINCT `sdg_indicators`.`code` SEPARATOR ', ') AS `sdg_code`,
                GROUP_CONCAT(DISTINCT  `indicators`.`group_name` SEPARATOR ', ') AS `group_name`,
                GROUP_CONCAT(DISTINCT `indicators`.`subgroup_name` SEPARATOR ', ') AS `subgroup_name`,
                `datasets`.`description` AS `dataset_description`,
                GROUP_CONCAT( `users`.`name` SEPARATOR ', ') AS `author`

                FROM ((`scripts` 

                    JOIN `link_scripts_indicators` ON((`scripts`.`id` = `link_scripts_indicators`.`script_id`))) 
                    JOIN `indicators` on((`link_scripts_indicators`.`indicator_id` = `indicators`.`id`)))
                    JOIN `sdg_indicators`on `indicators`.`sdg_indicator_id` = `sdg_indicators`.`id`
                    JOIN `datasets` on `indicators`.`dataset_id` = `datasets`.`id`
                    JOIN `users` on `scripts`.`author_id` = `users`.`id`

                GROUP BY `dataset_id`; 
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
