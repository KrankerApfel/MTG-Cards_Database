<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
 <html lang="en">
 <head>
  <meta http-equiv="content-type" content="text/html; charset=utf-8">
  <link rel="stylesheet" href="css/style.css">
  <title>Magic Card Database</title>
  <?php include 'src/functions.php' ;?>
  <?php  if(!isset($_GET['page'])){$_GET['page'] = 'top';} ?>
</head>
<body>
  <div id="top">

  </div>
  <?php include 'src/navbar.php' ?>
  <header class="page-header">
    <div id="header-container">
      <div class="header-tag">
          <h1>Magic the Gathering Database</h1>
          <p> Valentin Thomas | Tahina Rakotomanampison | Oriane Dejoie | Sonny Randriamanga</p>
      </div>
      <div id="header-texte">
        <h1>Texte d'intro</h1>
        <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p>
      </div>
    </div>
    <a href="#a-propos"><div class="arrow-down"><img src="img/arrow.png" alt="suivant"></div></a>


    </header>

    <main>
      <div class="main-container">
        <div id="a-propos">
          <h1>Histoire et lore</h1>
          <p>
            Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
          </p>
        </div>
      </div>

      <div class="main-container">
        <div id="carte-explication">
          <h1>Que contient une carte ?</h1>
          <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p>
          <img src="" alt="schema expliquant les propriétés d'une carte">
        </div>
      </div>

      <div class="main-container">
        <div id="features">
          <h1>Que propose cette base de donnée ?</h1>
          <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p>
          <a href="#">accéder à la base de donnée</a>
        </div>
      </div>
    </main>
    <div id="membres">
      <h1>La team</h1>
      <p>Ce projet à était réalisé dans le cadre du cours de base de donnée de notre troisième année de licence informatique à l'université du Havre.</p>
      <p>présentation de l'équipe :
        <ul>
          <li>Valentin</li>
          <li>Tahina</li>
          <li>Sonny</li>
          <li>Oriane</li>
        </ul>
      </p>
    </div>
    <?php include 'src/footer.php' ?>
</body>
</html>
