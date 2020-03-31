<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class AddOnDeleteCascadeToLinkScriptsIndicators extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::table('link_scripts_indicators', function (Blueprint $table) {
            $table->dropForeign(['script_id']);
            $table->dropForeign(['indicator_id']);
            $table->foreign('script_id')->references('id')->on('scripts')->onDelete('cascade');
            $table->foreign('indicator_id')->references('id')->on('indicators')->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::table('link_scripts_indicators', function (Blueprint $table) {
            
        });
    }
}
