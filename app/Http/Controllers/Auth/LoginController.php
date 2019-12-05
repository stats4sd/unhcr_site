<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use App\User;
use Illuminate\Foundation\Auth\AuthenticatesUsers;
use Illuminate\Support\Facades\Auth;
use Socialite;

class LoginController extends Controller
{
    /*
    |--------------------------------------------------------------------------
    | Login Controller
    |--------------------------------------------------------------------------
    |
    | This controller handles authenticating users for the application and
    | redirecting them to your home screen. The controller uses a trait
    | to conveniently provide its functionality to your applications.
    |
    */

    use AuthenticatesUsers;

    /**
     * Where to redirect users after login.
     *
     * @var string
     */
    protected $redirectTo = '/admin/dashboard';

    /**
     * Create a new controller instance.
     *
     * @return void
     */
    public function __construct()
    {
        // $this->middleware('guest')->except('logout');
    }

    /**
     * Send User to Microsoft to be authenticated
     * @param  Socialite Provider $provider Not used
     * @return Redirect
     */
    public function redirectToProvider()
    {
        return Socialite::driver('azure')->redirect();
    }

    /**
     * Obtain the user information from Microsoft Azure.
     *
     * @return Response
     */
    public function handleProviderCallback()
    {
        $user = Socialite::driver('azure')->user();



        //only auth for @stats4sd.org users
        if(!preg_match("/@stats4sd\.org$/i", $user->getEmail())) {
            $message = 'Your domain is not registered on this site.';
            abort(403,$message);
        }


        $data = [
            'email' => $user->getEmail(),
            'azure_id' => $user->id,
            'name' => $user->user['displayName']
        ];

        // $test = User::where('email',$data['email'])->first();

        // dd($test);

        Auth::login(User::where('email',$data['email'])->firstOrCreate(
            [
                'email' => $data['email']
            ],
            [
                'name' => $data['name'],
                'azure_id' => $data['azure_id']
            ]
        ));

        //if user exists, but has not yet been linked to Azure, add the link:
        if(!Auth::user()->azure_id) {

            $user = Auth::user();
            $user->azure_id = $data['azure_id'];
            $user->save();

        }

        return redirect(config('backpack.base.route_prefix').'/dashboard');

    }


}
