<!DOCTYPE html>
<html lang="en">
<head>
<title>Page Title</title>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
<!-- W3schools -->
<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
<link rel="stylesheet" href="https://www.w3schools.com/lib/w3-theme-black.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.3.0/css/font-awesome.min.css">
 <!-- jQuery -->
<script src="//code.jquery.com/jquery.js"></script>
<!-- DataTables -->
<script src="//cdn.datatables.net/1.10.7/js/jquery.dataTables.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
<link rel="stylesheet" href="https://use.typekit.net/qiu2fvt.css">
<style>

/* Style the body */

body, html {
    font-family: proxima-nova, sans-serif;
    font-weight: 400;
    font-style: normal;
    }
.nav {
    height: 100px;
}

.navitem {
  margin: auto;
  text-align: center;
  font-weight: 700;
}
.active{
  
        border-bottom: 5px solid #0072BC;
    
}
.nav:hover {
    background-color: #0072BC;
    color: #ffffff;

}

.disable:hover {
    background-color: white;
    color: #aaaaaa;

}

.disable {
  color: #aaaaaa;
}

/* Header/logo Title */
.header {
  /*text-align: center;*/
  background: #1abc9c;
  color: black;
}

/* Increase the font size of the heading */
.header h1 {
  font-size: 40px;
}

/* Sticky navbar - toggles between relative and fixed, depending on the scroll position. It is positioned relative until a given offset position is met in the viewport - then it "sticks" in place (like position:fixed). The sticky value is not supported in IE or Edge 15 and earlier versions. However, for these versions the navbar will inherit default position */
.navbar {
 /* overflow: hidden;*/
  background-color: white;
  position: sticky;
  position: -webkit-sticky;
  top: 0;
}

/* Style the navigation bar links */
.navbar a {
  float: left;
  display: block;
  color: black;
  text-align: center;
  padding: 14px 20px;
  text-decoration: none;
}


/* Right-aligned link */
.navbar a.right {
  float: right;
}

/* Column container */
.row {
  display: -ms-flexbox; /* IE10 */
  display: flex;
  -ms-flex-wrap: wrap; /* IE10 */
  flex-wrap: wrap;
}

/* Create two unequal columns that sits next to each other */
/* Sidebar/left column */
.side {
  -ms-flex: 30%; /* IE10 */
  flex: 30%;
  background-color: #f1f1f1;
  padding: 20px;
}

/* Main column */
.main {
  -ms-flex: 70%; /* IE10 */
  flex: 70%;
  background-color: white;
  padding: 20px;
}



/* Responsive layout - when the screen is less than 700px wide, make the two columns stack on top of each other instead of next to each other */
@media screen and (max-width: 700px) {
  .row {
    flex-direction: column;
  }
}

/* Responsive layout - when the screen is less than 400px wide, make the navigation links stack on top of each other instead of next to each other */
@media screen and (max-width: 400px) {
  .navbar a {
    float: none;
    width: 100%;
  }
}



/*-------------
    Home page
-------------*/

/* Container holding the image and the text */
.container {
  position: relative;
}


/* Bottom right text */
.text-block {
  position: absolute;
  top: 400px;
  color: white;
  padding-bottom: 50px;
  font-weight: 700;
  text-align: center;
  font-size: 55px;
  padding-left: 5%;
  padding-right: 5%;
  line-height: 1.2;
  width: 100%;
}

#image_home_page{
  width:100%;  
  object-fit:cover; 
  height:500px;
}

* {
  box-sizing: border-box;
}



/* Style the counter cards */
.card {
  box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);  /*this adds the "card" effect */
  padding: 16px;
  background-color: #f1f1f1;
}

/*
------------------------
Lessons & Learning
------------------------
*/

.lessons_top {
  background: url('/images/lessons_top.jpg') center center / cover no-repeat;
}


.center {
  display: block;
  margin-left: auto;
  margin-right: auto;
  width: 50%;
}

/*------------------------
Footer
------------------------*/

.footer {
  /*overflow: hidden;*/
  background-color: #0072BC;
  position: sticky;
  position: -webkit-sticky;
  padding: 20px;
  text-align: center;
  top: 0;
}

</style>
</head>
<body>
    <div class="container w-100 px-0"></div>
      <div class="row">
          <div class="col-3 px-0">
            <img src="images/logo.png" style="height: 100px; padding-left: 50px;">
          </div>
          <a class="col-3 nav px-0 {{ (request()->is('home')) ? 'active' : '' }}" href="{{ url('home') }}" style="text-decoration:none;">    
            <div class="navitem">Home</div>
          </a>
          <a class="col-3 nav px-0 {{ (request()->is('sdgs')) ? 'active' : '' }}" href="{{ url('sdgs') }}" style="text-decoration:none;">    
            <div class="navitem">SDG Indicators</div>
          </a>       
          <!-- <a class="col-3 nav disable px-0 {{ (request()->is('lessons')) ? 'active' : '' }}" href="#" style="text-decoration:line-through;">    
            <div class="navitem">Recommendations</div>
          </a> -->
      </div>
    </div>
@yield('content')


<div class="footer">
  <!-- Add icon library -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<!-- Add font awesome icons -->
    <!-- <a href="{{ url('login') }}" class="text">Admin Login</a> -->


</div>
@yield('footer')
</body>
