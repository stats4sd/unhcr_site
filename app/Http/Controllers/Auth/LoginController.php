<?php

namespace App\Http\Controllers\Auth;

use Backpack\CRUD\app\Http\Controllers\Auth\LoginController as BackpackLoginController;
use Illuminate\Http\Request;

class LoginController extends BackpackLoginController
{

    public $redirectTo = "";

    /**
     * Override the default method to inject the Ngos
     *
     * @return \Illuminate\Http\Response
     */
    public function showLoginForm()
    {
        return view('backpack::auth.login');
    }
}
