@extends('layouts.app')

@section('content')

<div class="container">

    <iframe src="{{ config('services.shiny.url') }}"></iframe>

@endsection