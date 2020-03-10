@extends('layouts.app')

@section('content')


<iframe
    width="100%"
    height="1000px"
    src="{{ config('services.shiny.url') }}"
>
</iframe>

@endsection