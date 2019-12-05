@extends('layouts.app')

@section('navbar')

<div class="header">
    <img src="images/iraq-children.jpg" style="width:100%"/>
    <div class="text-block">
        <h1>Every minute in 20018, 25 people wew forced to flee</h1>
    </div>
</div>

<div class="col-sm-12 centre" style="padding: 50px 50px;">

      <section class="content mb-5" id="introduction">
        <h1 style="text-align:center"><b>Introduction</b></h1>
        <p>Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr,  sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr,  sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.</p>
        <p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.</p>


      </section>


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

