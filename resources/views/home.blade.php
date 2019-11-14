@extends('layouts.app')
<body>
@section('navbar')

<div class="header">   
    <img src="images/iraq-children.jpg" style="width:100%" alt="Your Alt Tag is Here"/>
    <div class="text-block">
        <h1>Every minute in 20018, 25 people wew forced to flee</h1>
    </div>
</div>


<div class="row">
    @foreach($cards as $card)
    <div class="col-sm-4">
        <div class="card" style="height: 300px;">
          <div class="card-body">
            <h2 class="card-title" style="border-bottom: solid 1px;" >{{$card->card_title}}</h2>
            <p class="card-text">{{$card->card_body}}</p>
          </div>
        </div>
    </div>
    @endforeach
</div>
  



@endsection

@section('footer')
@endsection
</body>
</html>

