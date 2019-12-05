@extends('layouts.app')

@section('content')

<div class="alert alert-info">
    This page is just an example of how we can present a Shiny app within Laravel. The UI of the app below will need to be updated - as we currently have this 'nested' tab bar situation. But we can do that when we start putting serious effort into building the Shiny page(s).
</div>
<iframe
    width="100%"
    height="800px"
    src="{{ config('services.shiny.url') }}"
>
</iframe>


@endsection